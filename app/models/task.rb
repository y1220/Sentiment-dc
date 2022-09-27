class Task < ActiveRecord::Base

  belongs_to :list
  belongs_to :branch
  has_many :commits
  has_and_belongs_to_many :users

  include HTTParty
  base_uri "https://api.clickup.com/api/v2"

  enum status: { Open: 0, in_progress: 1, review: 2, Closed: 3 }
  enum priority: { urgent: 1, high: 2, normal: 3, low: 4 }


  scope :children_list, -> {where("parent IS NOT null")}
  scope :parent_list, -> {where("parent IS null")}


  def self.details
    hash= ApplicationRecord.authenticate
    team_id= PropertySetting.where(company: "ClickUp", key_name: "team_id").first.value_text
    space_id= PropertySetting.where(company: "ClickUp", key_name: "tasks_space_id").first.value_text

    response = get("/team/#{team_id}/task?subtasks=true&include_closed=true&space_ids%5B%5D=#{space_id}", query: hash[:query], headers: hash[:headers])
    JSON.parse(response.body)
  end

  def self.update
    response = Task.details
    @task_info = response['tasks']
    @task_info.each do |task|
      flag = 0
      t_created= Time.at(task['date_created'][0..9].to_i)
      dd_created = DateTime.parse(t_created.to_s)
      if !task['due_date'].nil?
        t_due= Time.at(task['date_created'][0..9].to_i)
        dd_due = DateTime.parse(t_due.to_s)
      end
      if !task['date_closed'].nil?
        t_closed= Time.at(task['date_closed'][0..9].to_i)
        dd_closed = DateTime.parse(t_closed.to_s)
      end
      if Space.where(cid: task['space']['id']).empty?
        @space= Space.new(cid: task['space']['id'])
        if !@space.save
          return false, "Error: Space creation failed"
        end
      end
      if List.where(cid: task['list']['id']).empty?
        @list= List.new(cid: task['list']['id'], name: task['list']['name'],
        space_id: Space.where(cid: task['space']['id']).first.id)
        if !@list.save
          return false, "Error: List creation failed"
        end
      end
      if task['custom_fields'].count != 0 && !task['custom_fields'][0]['type_config']['options'][0]['name'].nil? && !task['custom_fields'][0]['value'].nil?
        if !Branch.where(value: task['custom_fields'][0]['value']).present?
          @branch= Branch.new(name: task['custom_fields'][0]['type_config']['options'].select {|x|
            x['orderindex'] == task['custom_fields'][0]['value']}[0]['name'],
                              value: task['custom_fields'][0]['value'])
          if !@branch.save
            return false, "Error: Branch creation failed"
          else
            flag = 1
          end
        else
          @branch = Branch.where(value: task['custom_fields'][0]['value']).first
          @branch.name = task['custom_fields'][0]['type_config']['options'].select {|x| x['orderindex'] == task['custom_fields'][0]['value']}[0]['name']
        end
        if !@branch.save
          return false, "Error: Branch update failed"
        else
          flag = 1
        end
      end
      if Task.where(cid: task['id']).empty?
        @task = Task.new(cid: task['id'], name: task['name'], description: task['description'],
        parent: task['parent'], url: task['url'], # parent: inserted id is cid of parent task
        status: task['status']['status'] == 'in progress' ? 'in_progress' : task['status']['status'], archived: task['archived'],
        priority: task['priority'].nil? ? nil : task['priority']['priority'], due_date: dd_due ? dd_due : nil, date_created: dd_created,
        date_closed: dd_closed ? dd_closed : nil, list_id: List.where(cid: task['list']['id']).first.id)
        if !@task.save
          return false, "Error: Task creation failed"
        end
      else
        @task = Task.where(cid: task['id']).first
        @task.name = task['name']
        @task.description = task['description']
        @task.status = task['status']['status'] == 'in progress' ? 'in_progress' : task['status']['status']
        @task.priority = task['priority'].nil? ? nil : task['priority']['priority']
        @task.archived = task['archived']
        @task.due_date = dd_due ? dd_due : nil
        @task.date_closed = dd_closed ? dd_closed : nil
        if flag == 1
          @task.branch_id = @branch.id
        end
        if !@task.save
          return false, "Error: Task update failed"
        end
      end
      if task['assignees'].count != 0
        task['assignees'].each do |assignee|
          if User.where(cid: assignee['id']).empty?
            @user= User.new(cid: assignee['id'], username: assignee['username'])
            if !@user.save
              return false, "Error: User creation failed"
            end
          end
          if @task.users.include?(@user)
            @task.users << @user
            if !@task.save
              return false, "Error: Task User creation failed"
            end
          end
        end
      end
      if task['checklists'].count != 0
        task['checklists'].each do |checklist|
          if Checklist.where(cid: checklist['id']).empty?
            @checklist = Checklist.new(cid: checklist['id'], name: checklist['name'], resolved: checklist['resolved'],
                                      unresolved: checklist['unresolved'], task_id: @task.id)
          else
            @checklist = Checklist.where(cid: checklist['id']).first
            @checklist.name = checklist['name']
            @checklist.resolved = checklist['resolved']
            @checklist.unresolved = checklist['unresolved']
            @checklist.task_id = @task.id
          end
          if !@checklist.save
            return false, "Error: Checklist saving failed"
          end
          if checklist['items'].count != 0
            checklist['items'].each do |item|
              if Item.where(cid: item['id']).empty?
                @item= Item.new(cid: item['id'], name: item['name'], resolved: item['resolved'], checklist_id: @checklist.id,
                                user_id: item['assignee'] ? User.where(cid: item['assignee']['id']).first.id : User.all.first.id) #need to be fixed to allow it as optional
              else
                @item= Item.where(cid: item['id']).first
                @item.name = item['name']
                @item.resolved = item['resolved']
                @item.user_id = item['assignee'] ? User.where(cid: item['assignee']['id']).first.id : User.all.first.id #need to be fixed to allow it as optional
              end
              if !@item.save
                return false, "Error: Item saving failed"
              end
            end
          end
        end
      end
    end
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
