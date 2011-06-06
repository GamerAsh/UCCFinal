Factory.define :user do |user|
  user.name "Ashley Birtwell"
  user.email "birtwell@blackburn.ac.uk"
  user.password "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@blackburn.ac.uk"
end

Factory.define :thought do |thought|
  thought.content "Foobar"
  thought.association :user
end