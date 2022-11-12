class AddNidToDailyAvailabilities < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_availabilities, :nid, :string
  end
end
