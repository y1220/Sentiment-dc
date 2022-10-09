class AddIndexToDailyAvailabilities < ActiveRecord::Migration[5.2]
  def change
    add_index :daily_availabilities, [:user_id, :register_date], unique: true, name: 'availability_index'
  end
end
