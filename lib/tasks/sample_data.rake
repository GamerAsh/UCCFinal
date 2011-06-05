

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    make_users
    make_thoughts




  end
end

def make_users
      admin = User.create!(:name => "Example User",
                 :email => "birtwell@blackburn.ac.uk",
                 :password => "testing",
                 :password_confirmation => "testing")
    admin.toggle!(:admin)

    99.times do |n|
      name = Faker::Name.name
      email = "bb-#{n+1}@blackburn.ac.uk"
      password = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
end

def make_thoughts
      User.all(:limit => 6).each do |user|
      50.times do
        user.thoughts.create!(:content => Faker::Lorem.sentences(5))
      end
    end
end
