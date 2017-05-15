Fabricator(:task_master) do
  name {sequence(:name) {|i| "TaskMaster#{i}"}}
  description {Faker::Lorem.sentence}
  content {Faker::Lorem.sentence}
  subject
end
