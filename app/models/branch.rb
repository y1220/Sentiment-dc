class Branch < ApplicationRecord
    has_many :tasks
    has_many :commits

    include HTTParty
    base_uri "https://api.clickup.com/api/v2"

    def self.update(task_id, branch_id)
        hash= ApplicationRecord.authenticate_clickUp
        field_id= PropertySetting.where(company: "ClickUp", key_name: "gitbranch_field_id").first.value_text
        response = post("/task/#{task_id}/field/#{field_id}", body: {"value": branch_id}.to_json, query: hash[:query], headers: hash[:headers])
        JSON.parse(response.body)
    end
end
