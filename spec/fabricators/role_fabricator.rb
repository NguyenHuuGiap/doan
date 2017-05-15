Fabricator(:role) do
  name {sequence(:name) {|i| "Role#{i}"}}
end
