namespace :privileges_guide do
  namespace :sunspot do

    desc "Reindex all solr models that are located in your application's models directory."
    # This task depends on the standard Rails file naming \
    # conventions, in that the file name matches the defined class name. \
    # By default the indexing system works in batches of 50 records, you can \
    # set your own value for this by using the batch_size argument. You can \
    # also optionally define a list of models separated by a plus sign '+'
    #
    # $ rake getit:sunspot:index                # reindex all models
    # $ rake getit:sunspot:index[1000]          # reindex in batches of 1000
    # $ rake getit:sunspot:index[false]         # reindex without batching
    # $ rake getit:sunspot:index[,Post]         # reindex only the Post model
    # $ rake getit:sunspot:index[1000,Post]     # reindex only the Post model in
    #                                       # batchs of 1000
    # $ rake sunspot:index[,Post+Author]  # reindex Post and Author model
    task :index, [:batch_size, :models, :silence] => [:environment] do |t, args|
      # Retry once or gracefully fail for a 5xx error so we don't break reindexing
      with_session(Sunspot::SessionProxy::Retry5xxSessionProxy.new(Sunspot.session)) do

        # Set up general options for reindexing
        reindex_options = { :batch_commit => false }

        case args[:batch_size]
        when 'false'
          reindex_options[:batch_size] = nil
        when /^\d+$/
          reindex_options[:batch_size] = args[:batch_size].to_i if args[:batch_size].to_i > 0
        end

        # Load all the application's models. Models which invoke 'searchable' will register themselves
        # in Sunspot.searchable.
        Rails.application.eager_load!
        Rails::Engine.subclasses.each{|engine| engine.instance.eager_load!}

        if args[:models].present?
          # Choose a specific subset of models, if requested
          model_names = args[:models].split(/[+ ]/)
          sunspot_models = model_names.map{ |m| m.constantize }
        else
          # By default, reindex all searchable models
          sunspot_models = Sunspot.searchable
        end

        # Set up progress_bar to, ah, report progress unless the user has chosen to silence output
        begin
          require 'progress_bar'
          total_documents = sunspot_models.map { | m | m.count }.sum
          reindex_options[:progress_bar] = ProgressBar.new(total_documents)
        rescue LoadError => e
          $stdout.puts "Skipping progress bar: for progress reporting, add gem 'progress_bar' to your Gemfile"
        rescue Exception => e
          $stderr.puts "Error using progress bar: #{e.message}"
        end unless args[:silence]

        # Finally, invoke the class-level solr_reindex on each model
        sunspot_models.each do |model|
          model.solr_index(reindex_options)
        end
      end
    end

    # Swaps sunspot sessions for the duration of the block
    # Ensures the session is returned to normal in case this task is called from within the rails app
    # and not just a one-off from the command line
    def with_session(new_session)
      original_session = Sunspot.session
      Sunspot.session = new_session
      yield
    ensure
      Sunspot.session = original_session
    end

  end
end
