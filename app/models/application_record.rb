class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def self.authenticate
        query = {}
        headers = {"Content-Type"=> PropertySetting.where(company: "ClickUp", key_name: "Content-Type").first.value_text,
                    "Authorization"=> PropertySetting.where(company: "ClickUp", key_name: "Authorization").first.value_text}
        return {query: query, headers: headers}
    end
end
