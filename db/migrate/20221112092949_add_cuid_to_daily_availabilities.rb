class AddCuidToDailyAvailabilities < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_availabilities, :cuid, :string
  end
end
