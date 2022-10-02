class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def self.authenticate_clickUp
        query = {}
        headers = {"Content-Type"=> PropertySetting.where(company: "ClickUp", key_name: "Content-Type").first.value_text,
                    "Authorization"=> PropertySetting.where(company: "ClickUp", key_name: "Authorization").first.value_text}
        return {query: query, headers: headers}
    end

    def self.authenticate_gitHub
        query = {}
        headers = {}
        return {query: query, headers: headers}
    end
end
