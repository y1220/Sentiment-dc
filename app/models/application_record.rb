class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def self.authenticate_clickUp
        query = {}
        headers = {"Content-Type"=> PropertySetting.find_by(company: "ClickUp", key_name: "Content-Type").value_text,
                    "Authorization"=> PropertySetting.find_by(company: "ClickUp", key_name: "Authorization").value_text}
        return {query: query, headers: headers}
    end

    def self.authenticate_notion
        query = {}
        headers = {"Content-Type"=> "application/json",
                    "Notion-Version"=> "2022-02-22",
                    "Authorization"=> PropertySetting.find_by(company: "Notion", key_name: "Authorization").value_text}
        return {query: query, headers: headers}
    end

    def self.authenticate_gitHub
        query = {}
        headers = {}
        return {query: query, headers: headers}
    end
end
