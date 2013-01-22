namespace :privileges_guide do

  desc "Duplication patron status permissions"
  task :duplicate_permissions => :environment do

=begin    
    This was created as a work saving task
    Manually run this task to duplicate patron status permissions
    
    Patron Status completed	Copy to patron status
    57 NYU Undergraduate=	55 NYU Masters  54 NYU PHD  61 NYU TA

    50 NYU Faculty	=62 NYU Research Faculty   51 NYU Admin
    NYU Law School Student	=NYU Law School Faculty
    NYU Dental Student=	NYU Dental Faculty
    77 NYU Poly Undergrad=	72 NYU Poly Graduate  74 NYU PHD Student
=end

    # Associative array in the form "existing_patron_status_code" => [array_of_patron_status_to_duplicate_to]
    patrons = {
      "57" => ["55","54","61"], 
      "50" => ["62","51"], 
      "nyu_ag_noaleph_law" => ["nyu_ag_noaleph_law_faculty"], 
      "nyu_ag_noaleph_dental_student" => ["nyu_ag_noaleph_dental_faculty"],
      "77" => ["72","74"],
      "37" => ["35","34"], 
      "97" => ["90"], 
      "07" => ["05"], 
      "69" => ["nyu_ag_noaleph_sponsored_borrower"]
    }
    
    patrons.keys.each do |p|
      patrons_to_copy = patrons[p]
      patrons_to_copy.each do |ptc|
        patron_status_permissions = PatronStatusPermission.find(:all, :conditions => "patron_status_code = '#{p}'")
        patron_status_permissions.each do |psp|
	        this_perm = Permission.find(:first, :conditions => "code IN (SELECT permission_code FROM permission_values WHERE id = '#{psp.permission_value_id}')")
          old_psp = PatronStatusPermission.find(:first, :conditions => "patron_status_code = '#{ptc}' AND sublibrary_code = '#{psp.sublibrary_code}' AND permission_value_id IN (SELECT id FROM permission_values WHERE permission_code = '#{this_perm.code}')")
          if old_psp.nil?
            #p PatronStatusPermission.new(:patron_status_code => ptc, :sublibrary_code => psp.sublibrary_code, :permission_value_id => psp.permission_value_id, :visible => psp.visible, :from_aleph => 0)
            PatronStatusPermission.create(:patron_status_code => ptc, :sublibrary_code => psp.sublibrary_code, :permission_value_id => psp.permission_value_id, :visible => psp.visible, :from_aleph => 0)
          else
            old_psp.update_attributes(:visible=>psp.visible)
            old_psp.save
          end
        end    
      end
    end
    
  end
  
end
