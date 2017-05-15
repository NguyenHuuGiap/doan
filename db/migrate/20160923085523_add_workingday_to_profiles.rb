class AddWorkingdayToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :working_day, :decimal, precision: 2, scale: 1
  end
end
