namespace :users do

  desc 'Creates an admin role, usage: users:create_admin_role'
  task :create_admin_role  => :environment do
    Role.where(name: "admin").first_or_create!
  end

  desc 'Creates an admin user, usage: users:create_admin_user["email@exmaple.com","password"]'
  task :create_admin_user, [:email, :password] => :environment do |task, args|
    if (args.email.present? && args.password.present?)
      user = User.where(email: args.email).first_or_create!(password: args.password)
      admin = Role.where(name: "admin").first_or_create!
      unless admin.users.include?(user)
        admin.users << user
        admin.save!
        puts "Administrator created: #{user.email}"
      end
    else
      abort("ERROR: missing email and password")
    end
  end

end