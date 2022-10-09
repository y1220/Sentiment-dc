class CreateDailyReports < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_reports do |t|
      t.integer :task_score
      t.integer :need_help
      t.integer :user_id
      t.date :register_date

      t.timestamps
    end
  end
end
