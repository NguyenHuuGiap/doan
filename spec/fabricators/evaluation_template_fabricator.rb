Fabricator(:evaluation_template) do
  name {sequence(:name) {|i| "EvaluationTemplate#{i}"}}
  min_point 1
  max_point 5
end
