# lib/tasks/fix_user_roles.rake
namespace :users do
  desc 'Audit and fix user roles, ensuring admins and consultants are set to admin'
  task fix_roles: :environment do
    puts 'Auditing user roles...'
    User.where(role: 'consultant').each do |user|
      puts "Updating user #{user.email} from consultant to admin"
      user.update!(role: 'admin')
    end
    puts 'Role audit complete.'
  end
end