class Branch < ApplicationRecord
    has_many :tasks
    has_many :commits
end
