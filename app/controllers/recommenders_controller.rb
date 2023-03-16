class RecommendersController < ApplicationController
  @@user_id = 1
  @@repo_id = 5

  def index
    @users = User.all.order("id")[0..3]
    @task_name_list= Task.parent_list_of_repo(@@repo_id).last(6)
    @scores= []
    @task_name_list.each do |task|
      tmp= [task.complexity_score, task.priority_score, task.duration_score, task.frontend_score, task.backend_score, task.infrastructure_score, task.data_manipulation_score]
      @scores << tmp
    end
    #@scores= [
    #[60.2, 33.2, 43.6, 16.8, 25.5, 53.8, 81.2],
    #[32.6, 73.2, 92.4, 13.6, 18.2, 28.0, 22.6],
    #[82.3, 72.1, 11.3, 9.2, 18.5, 51.7, 28.3],
    #[82.6, 11.5, 27.9, 45.7, 25.9, 33.3, 51.2],
    #[82.3, 11.3, 29.3, 48.7, 24.8, 16.2, 18.7],
    #[16.3, 18.2, 26.3, 52.4, 42.7, 16.3, 36.9]
    #]
    @tasks = User.find(@@user_id).tasks.last(3) #NEED FIX: fetch selected user
    @radar_scores= [
      {   name: @tasks.first.name,
        scores: [82.6, 11.5, 27.9, 45.7, 25.9, 33.3, 51.2]},
      {   name: @tasks.second.name,
        scores:[82.3, 11.3, 29.3, 48.7, 24.8, 16.2, 18.7]},
      {   name: @tasks.third.name,
        scores:[16.3, 18.2, 26.3, 52.4, 42.7, 16.3, 36.9]}
      ]
    @analyzed_names = ['Integration for AAA', 'Integration for BBB', 'Integration for CCC']
    @names = User.first(5).map(&:username)
    @analysis = [11, 16, 7, 3, 14] #NEED FIX: analysis need to be implemented based on availability, skill set etc
  end

  def update_clickup
    User.update
    @users = User.all
    @tasks = User.find(@@user_id).tasks
    redirect_to action: "index"
  end
end
