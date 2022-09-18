class Task < ActiveRecord::Base
  include HTTParty
  belongs_to :list
  has_and_belongs_to_many :users
  base_uri "https://api.clickup.com/api/v2"

  def self.details
    query = {}
    headers = {"Content-Type"=> PropertySetting.where(company: "ClickUp", key_name: "Content-Type").first.value_text,
               "Authorization"=> PropertySetting.where(company: "ClickUp", key_name: "Authorization").first.value_text}
    response = get("/team/#{PropertySetting.where(company: "ClickUp", key_name: "team_id").first.value_text}/task?subtasks=true&include_closed=true", query: query, headers: headers)
    JSON.parse(response.body)
  end
end
