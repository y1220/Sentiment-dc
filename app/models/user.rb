class User < ActiveRecord::Base
    has_many :commits
    has_and_belongs_to_many :tasks
    has_and_belongs_to_many :availabilities, after_add: :update_last_status

    include HTTParty
    base_uri "https://api.clickup.com/api/v2"

    enum last_status: { available: 1, normal: 2, busy: 3 }
    enum role: { 'FE developer' => 1, 'BE developer' => 2, 'Fullstack developer'=> 3, 'Data engineer'=> 4 }

    def update_last_status availability
        self.last_status = availability.id
    end

    def self.details
        hash= ApplicationRecord.authenticate_clickUp
        team_id= PropertySetting.find_by(company: "ClickUp", key_name: "team_id").value_text
        list_id= PropertySetting.find_by(company: "ClickUp", key_name: "availabilities_list_id").value_text

        response = get("/team/#{team_id}/task?subtasks=true&include_closed=true&list_ids%5B%5D=#{list_id}", query: hash[:query], headers: hash[:headers])
        JSON.parse(response.body)
    end

    def self.update
        response = User.details
        @user_info = response['tasks']
        @user_info.each do |user|
            if User.where(cid: user['assignees'][0]['id']).empty?
                @user = User.new(cid: user['id'], username: user['name'], comment: user['description'],
                                last_status: user['status']['status'])
                if !@user.save
                    return false, "Error: User creation failed"
                end
            else
                @user = User.find_by(cid: user['assignees'][0]['id'])
                @user.username = user['name']
                @user.comment = user['description']
                @user.last_status = user['status']['status']
                if !@user.save
                    return false, "Error: User update failed"
                end
            end
        end
    end

    def active_tasks
        self.tasks.select { |task| task.status != "Closed" }
    end
end
