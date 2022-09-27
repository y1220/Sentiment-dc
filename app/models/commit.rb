class Commit < ApplicationRecord
  belongs_to :user
  belongs_to :task
  belongs_to :branch
end
