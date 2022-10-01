class Commit < ApplicationRecord
  belongs_to :user
  belongs_to :task
  belongs_to :branch

  def format_date_created
    self.date_created.present? ? self.date_created.strftime('%m-%d-%Y %l:%M %p') : nil
  end

  def self.last_commit_in_branch(bid)
    Commit.where(branch_id: bid).last.format_date_created
  end

end
