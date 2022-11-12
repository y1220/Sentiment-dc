class AddCtidToDailyReports < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_reports, :ct_id, :string
  end
end
