Fabricator(:course) do
  name {sequence(:name) {|i| "Course Master#{i + 1}"}}
  description {Faker::Lorem.sentence}
  content {Faker::Lorem.sentence}
  start_date DateTime.now
  end_date DateTime.now + 5.day
end
