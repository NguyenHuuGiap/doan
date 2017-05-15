Fabricator(:rank) do |i|
  rank_value {sequence(:rank_value) {|i| i + 1}}
  begin_point {sequence(:begin_point) {|i| i * 5}}
  end_point {sequence(:end_point) {|i| i * 5 + 4}}
end
