Fabricator(:task) do
  name {sequence(:name) {|i| "Task#{i}"}}
  description {Faker::Lorem.sentence}
  subject
end
