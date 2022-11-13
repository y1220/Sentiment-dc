class NotionController < ApplicationController
  @@user_id = 1
  def index
    @user_list= User.all
    @users= @user_list.map(&:username) #TODO: adjust to show team member
    @dates= []
    @tasks=[]
    @availabiity = []
    tasks= User.find(@@user_id).active_tasks
    tasks.each_with_index do |task, i|
      (@dates = DailyReport.where(user_id: @@user_id, task_id: task.id).sort_by(&:register_date).last(5).map{|x| x.register_date}) if i == 0
      scores= []
      @dates.each do |date|
        if i == 0
          score = DailyAvailability.find_by(user_id: @@user_id, register_date: date)
          score.present? ? @availabiity << score.availability_score*20 :  @availabiity << 0
        end
        score= DailyReport.find_by(user_id: @@user_id, task_id: task.id, register_date: date)
        score.present? ? scores << score.task_score*20 : scores << 0
      end
      @tasks << {name: task.name, scores: scores}
    end
    @dates = @dates.map{|x| x.strftime('%Y-%m-%d')}
    @create_report_db= PropertySetting.find_by(key_name: "daily_reports_db_id").value_text.present? ? false : true
    @create_availability_db= PropertySetting.find_by(key_name: "daily_availabilities_db_id").value_text.present? ? false : true
    report_link= PropertySetting.find_by(key_name: "daily_reports_link")
    availability_link= PropertySetting.find_by(key_name: "daily_availabilities_link")
    @report_link= report_link ? report_link.value_text : "/reports/daily"
    @availability_link= availability_link ? availability_link.value_text : "/reports/daily"
    @task_list= User.find(@@user_id).active_tasks
    @duration_list= ['latest', 'weekly average']
  end

  def select_user
    @user_id = params['uid']
    @dates= []
    @tasks=[]
    @availabiity = []
    tasks= User.find(@user_id).active_tasks
    tasks.each_with_index do |task, i|
      (@dates = DailyReport.where(user_id: @user_id, task_id: task.id).sort_by(&:register_date).last(5).map{|x| x.register_date}) if i == 0
      scores= []
      @dates.each do |date|
        if i == 0
          score = DailyAvailability.find_by(user_id: @user_id, register_date: date)
          score.present? ? @availabiity << score.availability_score*20 :  @availabiity << 0
        end
        score= DailyReport.find_by(user_id: @user_id, task_id: task.id, register_date: date)
        score.present? ? scores << score.task_score*20 : scores << 0
      end
      @tasks << {name: task.name, scores: scores}
    end
    @dates = @dates.map{|x| x.strftime('%Y-%m-%d')}
    return render json: { dates: @dates, tasks: @tasks, availabiity: @availabiity}
  end

  def import_daily_reports
  end

  def import_daily_availabilities
  end
end
