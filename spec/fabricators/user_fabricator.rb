Fabricator(:user) do
  name {sequence(:name) {|i| "User#{i}"}}
  email {sequence(:email) {|i| "email#{i}@gmail.com"}}
  password "12345678"
  password_confirmation "12345678"
  role_id 3
end
