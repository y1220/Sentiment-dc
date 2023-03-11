class GitIssue < ApplicationRecord
  belongs_to :repository
  belongs_to :task
end
