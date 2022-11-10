class AddRegisteredToDailyAvailabilities < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_availabilities, :registered, :boolean
  end
end
