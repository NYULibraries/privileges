module Utilities
  module Common
    class << self
    
      # Determine if the current process is running from a rake task
      # This is decided by seeing if the pid file exists.
      def running_from_rake? rake_pid_file = "tmp/pids/load_aleph.pid"
        @running_from_rake ||= File.exists? File.join(Rails.root, rake_pid_file)
      end
    
      # Alias for negation of running from rake 
      # Semantic choice for title made because models should not be auto-indexed from rake
      def index?
        !running_from_rake?
      end
    
   end 
  end
end