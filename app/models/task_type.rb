class TaskType < ApplicationRecord
    has_and_belongs_to_many :tasks
end
