class TasksController < ApplicationController
  def index
  end

  def show
    response = Task.details
    @task_info = response['tasks']
    @task_info.each do |task|
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
      if Task.where(cid: task['id']).empty?
        @task = Task.new(cid: task['id'], name: task['name'], description: task['description'],
        parent: task['parent']? true : false, url: task['url'],
        status: task['status']['status'], archived: task['archived'],
        due_date: dd_due ? dd_due : nil, date_created: dd_created,
        date_closed: dd_closed ? dd_closed : nil, list_id: List.where(cid: task['list']['id']).first.id)
        if !@task.save
          return false, "Error: Task creation failed"
        end
      else
        @task =  Task.where(cid: task['id']).first
        @task.name = task['name']
        @task.description = task['description']
        @task.status = task['status']['status']
        @task.archived = task['archived']
        @task.due_date = dd_due ? dd_due : nil
        @task.date_closed = dd_closed ? dd_closed : nil
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
                                      unresolved: checklist['unresolved'], task_id: task['id'])
            if !@checklist.save
              return false, "Error: Checklist creation failed"
            end
          end
          checklist['items'].each do |item|
            Item.where(cid: item['id']).empty?
            @item= Item.new(cid: item['id'], name: item['name'], resolved: item['resolved'], checklist_id: checklist['id'],
                            user_id: item['assignee'] ? User.where(cid: item['assignee']['id']).first : User.all.first)
            if !@item.save
              return false, "Error: Item creation failed"
            end
          end
        end
      end
    end
    @tasks = Task.all
  end
end
