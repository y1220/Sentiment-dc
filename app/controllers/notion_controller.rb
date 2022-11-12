class NotionController < ApplicationController
  def index
    @users= User.all.map(&:username) #TODO: adjust to show team member
    @dates= []
    @tasks=[]
    @availabiity = []
    tasks= User.first.tasks
    tasks.each_with_index do |task, i|
      (@dates = DailyReport.where(user_id: 1, task_id: task.id).sort_by(&:register_date).last(5).map{|x| x.register_date}) if i == 0
      scores= []
      @dates.each do |date|
        if i == 0
          score = DailyAvailability.find_by(user_id: 1, register_date: date)
          score.present? ? @availabiity << score.availability_score*20 :  @availabiity << 0
        end
        score= DailyReport.find_by(user_id: 1, task_id: task.id, register_date: date)
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
  end

  def import_daily_reports
  end

  def import_daily_availabilities
  end
end
