class Repository < ApplicationRecord
    def format_created_at
        self.created_at.present? ? self.created_at.strftime('%m-%d-%Y %l:%M %p') : nil
    end

    def format_updated_at
        self.updated_at.present? ? self.updated_at.strftime('%m-%d-%Y %l:%M %p') : nil
    end
end
