#TODO: Separate into modules and class functions to simplify 
namespace :privileges_guide do

  desc "Refresh Aleph DB Config"
  task :load_aleph => :environment do
    
    start = Time.now
    
    Rake::Task['exlibris:aleph:refresh'].execute

    tab_helper = Exlibris::Aleph::TabHelper.instance
    patron_permissions = tab_helper.patron_permissions
    patrons = tab_helper.patrons
    sublibraries = tab_helper.sub_libraries
    
    FileUtils.mkdir_p File.join(Rails.root, "tmp/pids")
    pid_file = "#{Rails.root}/tmp/pids/load_aleph.pid"
    raise 'pid file exists!' if File.exists? pid_file
    File.open(pid_file, 'w'){|f| f.write Process.pid}
    begin
      plog "Loading patron statuses..."
      load_patron_statuses(patrons, cleanup = true)
      plog "Loading sub libraries..."
      load_sublibraries(sublibraries, cleanup = true)
      plog "Loading patron permissions..."
      load_patron_status_permissions(patron_permissions, cleanup = true)
      plog "Task completed in: #{Time.now - start}\n\n"
      plog "SUCCESS"
    rescue
      plog 'FAILED'
      raise
    ensure
      File.delete pid_file
    end
    
  end
  
  # Find or create PatronStatus objects by unique ALEPH code
  def load_patron_statuses(patrons, cleanup = false)
    all_patron_statuses_in_aleph = []
    ActiveRecord::Base.transaction do
      patrons.each do |adm, patron_statuses|
         patron_statuses.keys.each do |patron_status_code|
          patron_in_db = PatronStatus.find_or_create_by_code(patron_status_code)
          # If no Web Text exists in the database, then copy Web Text from ALEPH config
          patron_web_text = (patron_in_db.web_text.nil?) ? patron_statuses[patron_status_code][:text] : patron_in_db.web_text
          patron_in_db.original_text = patron_statuses[patron_status_code][:text]
          patron_in_db.web_text = patron_web_text
          patron_in_db.from_aleph = true # Flag as an ALEPH item
          patron_in_db.save
        end 
        all_patron_statuses_in_aleph |= patron_statuses.keys
      end
    end
    if cleanup
      plog "Cleaning up patron statuses..."
      #Find all patron statuses previously loaded from aleph
      existing_patron_statuses_from_aleph = PatronStatus.where(:from_aleph => true).map(&:code)
      plog "Deleting patron statuses: #{existing_patron_statuses_from_aleph - all_patron_statuses_in_aleph.uniq}"
      #Delete all statuses which were previouly loaded from aleph, but are no longer in aleph
      deleted_patron_statuses = PatronStatus.destroy_all(:code => existing_patron_statuses_from_aleph - all_patron_statuses_in_aleph.uniq, :from_aleph => true)
      plog "Deleted #{deleted_patron_statuses.count} patron statuses"
    end
  end 
      
  # Find or craete Sublibrary objects by unique ALEPH code
  def load_sublibraries(sublibraries, cleanup = false)
    ActiveRecord::Base.transaction do
     sublibraries.keys.each do |sublibrary_code|
       sublibrary_in_db = Sublibrary.find_or_create_by_code(sublibrary_code)
       # If no Web Text exists in the database, then copy Web Text from ALEPH config
       sublibrary_web_text = (sublibrary_in_db.web_text.nil?) ? sublibraries[sublibrary_code][:text] : sublibrary_in_db.web_text
       sublibrary_in_db.original_text = sublibraries[sublibrary_code][:text]
       sublibrary_in_db.web_text = sublibrary_web_text
       sublibrary_in_db.from_aleph = true # Flag as an ALEPH item
       sublibrary_in_db.save
     end
    end
    if cleanup
      plog "Cleaning up sublibraries..."
      #Find all sublibraries previously loaded from aleph
      existing_sublibraries_from_aleph = Sublibrary.where(:from_aleph => true).map(&:code)
      plog "Deleting sublibraries: #{existing_sublibraries_from_aleph - sublibraries.keys}"
      #Delete all sublibraries which were previouly loaded from aleph, but are no longer in aleph
      deleted_sublibraries = Sublibrary.destroy_all(:code => existing_sublibraries_from_aleph - sublibraries.keys, :from_aleph => true)
      plog "Deleted #{deleted_sublibraries.count} sublibraries"
    end
  end
  
  def load_patron_status_permissions(patron_permissions, cleanup = false)
    all_permission_codes, all_permission_values = [], []
    #Loop through all patron permissions for each ADM
    ActiveRecord::Base.transaction do
      patron_permissions.each do |adm, tab31|
        #Loop through each set of tab31 keys, which are organized by sublibrary code
        tab31.keys.each do |sublibrary_code|
          #Loop through each sublibrary to get patron status permissions for that sublibrary
          tab31[sublibrary_code].keys.each do |patron_status_code|
            #These are the permissions for this sublibrary/patron status pair, saved as a hash
            permissions = tab31[sublibrary_code][patron_status_code]
            #This is the sublibrary
            sublibrary_code = permissions[:sub_library]
            #This is the patron status
            patron_status_code = permissions[:patron_status]
            #Loop through each of these permissions
            permissions.keys.each do |permission|
              unless permission == :sub_library || permission == :patron_status
                all_permission_codes.push(permission.to_s)
                all_permission_values.push({permission.to_sym => permissions[permission]})
                #############################
                # 1. Find/Create Permission #
                #############################
                # Find or create Permission objects by unique ALEPH code
                permission_code = permission.to_s
                permission_in_db = Permission.find_or_create_by_code(permission_code)
                # If no Web Text exists in the database, then copy Code from ALEPH config, but replace underscores with spaces
                permission_web_text = (permission_in_db.web_text.blank?) ? permission_code.capitalize.gsub("_"," ") : permission_in_db.web_text
                permission_in_db.web_text = permission_web_text
                permission_in_db.from_aleph = true # Flag as an ALEPH item
                permission_in_db.save
                ##################################
                # 2. Find/Create PermissionValue #
                ##################################
                # Find or create PermissionValue objects by combined key permission_code, permission_value_code
                permission_value_code = permissions[permission]
                permission_value_in_db = PermissionValue.find_or_create_by_code_and_permission_code(permission_value_code, permission_code)
                # If no Web Text exists in the database, then copy Code from ALEPH config
                permission_value_web_text = (permission_value_in_db.web_text.blank?) ? permission_value_code : permission_value_in_db.web_text
                permission_value_in_db.web_text = permission_value_web_text
                permission_value_in_db.from_aleph = true # Flag as an ALEPH item
                permission_value_in_db.save
                #########################################
                # 3. Find/Create PatronStatusPermission # 
                #########################################
                # After we've either created or found Permission and PermissionValue, create PatronStatusPermission
                patron_status_permission_in_db = PatronStatusPermission.find_or_create_by_patron_status_code_and_sublibrary_code_and_permission_value_id(patron_status_code, sublibrary_code, permission_value_in_db.id)
                patron_status_permission_in_db.from_aleph = true # Flag as an ALEPH item
                patron_status_permission_in_db.save
              end
            end
          end
        end
      end
    end
    if cleanup
      plog "Cleaning up permissions..."
      #Find all permissions previously loaded from aleph
      existing_permissions_from_aleph = Permission.where(:from_aleph => true).map(&:code)
      plog "Deleting permissions: #{existing_permissions_from_aleph - all_permission_codes.uniq}"
      deleted_permissions = Permission.destroy_all(:code => existing_permissions_from_aleph - all_permission_codes.uniq, :from_aleph => true)
      plog "Deleted #{deleted_permissions.count} permissions"
      #
      #
      # Deleting permissions deletes permission values
    end
  end
  
  def plog log_me
    logger.info "[#{Time.now}] #{log_me}"
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/aleph_refresh.log")
  end
 
end

