Fabricator(:subject) do
  name {sequence(:name) {|i| "Subject#{i}"}}
  description {Faker::Lorem.sentence}
  content {Faker::Lorem.sentence}
  during_time {Faker::Number.between(1, 10)}

  after_create do |subject|
    5.times do
      Fabricate :task_master, subject: subject
    end
  end
end
