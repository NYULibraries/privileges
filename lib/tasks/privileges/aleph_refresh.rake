#TODO: Separate into modules and class functions to simplify
require 'exlibris-nyu'

namespace :privileges do

  desc "Refresh Aleph DB Config"
  task load_aleph: :environment do

    start = Time.now

    tables_manager = Exlibris::Aleph::TablesManager.instance
    patron_circulation_policies = tables_manager.patron_circulation_policies
    patron_statuses = tables_manager.patron_statuses
    sublibraries = tables_manager.sub_libraries

    FileUtils.mkdir_p File.join(Rails.root, "tmp/pids")
    pid_file = "#{Rails.root}/tmp/pids/load_aleph.pid"
    raise 'pid file exists!' if File.exists? pid_file
    File.open(pid_file, 'w'){|f| f.write Process.pid}
    begin
      plog "Loading patron statuses..."
      load_patron_statuses(patron_statuses, cleanup = true)
      plog "Loading sub libraries..."
      load_sublibraries(sublibraries, cleanup = true)
      plog "Loading patron permissions..."
      load_patron_status_permissions(patron_circulation_policies, cleanup = true)
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
  def load_patron_statuses(patron_statuses_by_adm, cleanup = false)
    all_codes = []
    ActiveRecord::Base.transaction do
      patron_statuses_by_adm.each do |adm, patron_statuses|
        patron_statuses.each do |patron_status|
          patron_status_record =
            PatronStatus.find_or_initialize_by(code: patron_status.code)
          if patron_status_record.new_record?
            # If no Web Text exists in the database,
            # then copy Web Text from ALEPH config
            patron_status_record.web_text = patron_status.display
            patron_status_record.visible = false # Default to hidden for new values
          end
          patron_status_record.original_text = patron_status.display
          patron_status_record.from_aleph = true # Flag as an ALEPH item
          patron_status_record.save
        end
        all_codes |= patron_statuses.map(&:code)
      end
    end
    if cleanup
      plog "Cleaning up patron statuses..."
      # Get the unique codes
      all_codes.uniq!
      # Find all patron statuses previously loaded from aleph
      old_codes = PatronStatus.where(from_aleph: true).map(&:code)
      # Determine the ones that have been deleted from Aleph since the last load
      deleted_codes = all_codes - old_codes
      plog "Deleting patron statuses with codes: #{deleted_codes}"
      #Delete them from Privileges
      deleted_patron_statuses =
        PatronStatus
          .where(code: deleted_codes, from_aleph: true)
          .destroy_all

      plog "Deleted #{deleted_patron_statuses.count} patron statuses"
    end
  end

  # Find or craete Sublibrary objects by unique ALEPH code
  def load_sublibraries(sublibraries, cleanup = false)
    ActiveRecord::Base.transaction do
      sublibraries.each do |sublibrary|
        sublibrary_record =
          Sublibrary.find_or_initialize_by(code: sublibrary.code)
        if sublibrary_record.new_record?
          # If no Web Text exists in the database,
          # then copy Web Text from ALEPH config
          sublibrary_record.web_text = sublibrary.display
          sublibrary_record.visible = false # Default to hidden for new values
        end
        sublibrary_record.original_text = sublibrary.display
        sublibrary_record.from_aleph = true # Flag as an ALEPH item
        sublibrary_record.save
      end
    end
    if cleanup
      plog "Cleaning up sublibraries..."
      # Grab the sublibrary codes that were given
      all_codes = sublibraries.map(&:code).uniq
      # Find all sublibraries previously loaded from aleph
      old_codes = Sublibrary.where(from_aleph: true).map(&:code)
      # Determine the ones that have been deleted from Aleph since the last load
      deleted_codes = all_codes - old_codes
      plog "Deleting sublibraries with codes: #{deleted_codes}"
      #Delete all sublibraries which were previouly loaded from aleph, but are no longer in aleph
      deleted_sublibraries =
        Sublibrary
          .where(code: deleted_codes, from_aleph: true)
          .destroy_all

      plog "Deleted #{deleted_sublibraries.count} sublibraries"
    end
  end

  def load_patron_status_permissions(patron_circulation_policies_by_adm, cleanup = false)
    permission_mappings = {
      loan_permission: :borrow,
      photo_permission: :photocopy,
      multiple_hold_permission: :request_multiple,
      hold_permission: :request,
      renew_permission: :renew,
      hold_request_permission_for_item_on_shelf: :request_on_shelf,
      item_booking_permission: :book
    }
    all_codes = permission_mappings.keys
    all_value_codes = {}
    # Loop through all patron circulation policies
    ActiveRecord::Base.transaction do
      patron_circulation_policies_by_adm.each do |adm, patron_circulation_policies|
        patron_circulation_policies.each do |patron_circulation_policy|
          identifier = patron_circulation_policy.identifier
          privileges = patron_circulation_policy.privileges
          patron_status = identifier.status
          sublibrary = identifier.sub_library
          permission_mappings.each do |code, attribute|
            value_code = privileges.send(attribute)
            all_value_codes[code] = value_code
            #############################
            # 1. Find/Create Permission #
            #############################
            # Find or create Permission objects by unique ALEPH code
            permission_record = Permission.find_or_initialize_by(code: code)
            if permission_record.new_record?
              # If no Web Text exists in the database, then copy Code from ALEPH config, but replace underscores with spaces
              permission_record.web_text = code.to_s.capitalize.gsub("_"," ")
              permission_record.visible = false
            end
            permission_record.from_aleph = true # Flag as an ALEPH item
            permission_record.save
            ##################################
            # 2. Find/Create PermissionValue #
            ##################################
            # Find or create PermissionValue objects by combined key permission_code, permission_value_code
            permission_value_record =
              permission_record.permission_values.find_or_initialize_by(code: value_code)
            if permission_value_record.new_record?
              # If no Web Text exists in the database, then copy Code from ALEPH config
              permission_value_record.web_text = value_code
            end
            permission_value_record.from_aleph = true # Flag as an ALEPH item
            permission_value_record.save
            #########################################
            # 3. Find/Create PatronStatusPermission #
            #########################################
            # After we've either created or found Permission and PermissionValue, create PatronStatusPermission
            patron_status_permission_record =
              permission_value_record.patron_status_permissions.find_or_create_by(patron_status_code: patron_status.code, sublibrary_code: sublibrary.code)
            patron_status_permission_record.from_aleph = true # Flag as an ALEPH item
            patron_status_permission_record.save
          end
        end
      end
    end
  end

  def plog log_me
    logger.info "[#{Time.now}] #{log_me}"
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/aleph_refresh.log")
  end

end
