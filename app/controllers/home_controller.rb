class HomeController < ApplicationController
  @@user_id = 1
  def index
    @dates= []
    @tasks=[]
    @availabiity = []
    tasks= User.find(@@user_id).active_tasks
    tasks.each_with_index do |task, i|
      (@dates = DailyReport.where(user_id: 1, task_id: task.id).sort_by(&:register_date).last(5).map{|x| x.register_date}) if i == 0
      scores= []
      @dates.each do |date|
        if i == 0
          score = DailyAvailability.where(user_id: 1, register_date: date).first.availability_score
          score.present? ? @availabiity << score*20 :  @availabiity << 0
        end
        report= DailyReport.where(user_id: 1, task_id: task.id, register_date: date).first
        score= report ? report.task_score : 0
        score.present? ? scores << score*20 : scores << 0
      end
      @tasks << {name: task.name, scores: scores}
    end

    @dates = @dates.map{|x| x.strftime('%Y-%m-%d')}
  end
end
