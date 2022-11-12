class AddNidToDailyReports < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_reports, :nid, :string
  end
end
