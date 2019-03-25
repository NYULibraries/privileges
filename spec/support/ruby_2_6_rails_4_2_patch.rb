# Problem: "ThreadError: already initialized" error thrown in Ruby >= 2.6.0 in Rails < 5.
# This monkey patches the rails TestResponse class which causes this error.
# Source: https://github.com/rails/rails/issues/34790#issuecomment-450502805

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end