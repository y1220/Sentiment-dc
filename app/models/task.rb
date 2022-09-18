class Task < ActiveRecord::Base
  include HTTParty
  belongs_to :list
  has_and_belongs_to_many :users
  base_uri "https://api.clickup.com/api/v2"

  enum status: { Open: 0, in_progress: 1, review: 2, Closed: 3 }

  scope :children_list, -> {where("parent IS NOT null")}
  scope :parent_list, -> {where("parent IS null")}


  def self.details
    query = {}
    headers = {"Content-Type"=> PropertySetting.where(company: "ClickUp", key_name: "Content-Type").first.value_text,
               "Authorization"=> PropertySetting.where(company: "ClickUp", key_name: "Authorization").first.value_text}
    response = get("/team/#{PropertySetting.where(company: "ClickUp", key_name: "team_id").first.value_text}/task?subtasks=true&include_closed=true", query: query, headers: headers)
    JSON.parse(response.body)
  end

  def find_parent
    Task.where(cid: self.parent).present? ? Task.where(cid: self.parent).first : nil
  end

  def find_children
    Task.children_list.select{ |child| child.parent == self.cid }
  end

  def format_due_date
    self.due_date.present? ? self.due_date.strftime('%m-%d-%Y %l:%M %p') : nil
  end

  def format_date_created
    self.date_created.present? ? self.date_created.strftime('%m-%d-%Y %l:%M %p') : nil
  end

  def format_date_closed
    self.date_closed.present? ? self.date_closed.strftime('%m-%d-%Y %l:%M %p') : nil
  end

end
