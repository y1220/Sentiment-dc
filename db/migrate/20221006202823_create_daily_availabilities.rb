class CreateDailyAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_availabilities do |t|
      t.boolean :enable
      t.integer :availability_score
      t.integer :user_id
      t.date :register_date

      t.timestamps
    end
  end
end
