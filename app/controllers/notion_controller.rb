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

  def select_team_availabilities
    duration= params['duration'] == '1' ? 'past_week' : 'latest'
    cuid_list= Task.find(params['task']).users.map(&:cid)

    # Notion GET request
    response= ''
    availabilities= []

    if duration == 'past_week'
      response= DailyReport.get_past_week_team_availabilities(cuid_list)
      drafts = []
      response["results"].each do |result|
        object= {}
        object['cuid']= result["properties"]["ClickUp User id"]["rich_text"][0]["text"]["content"]
        object['score']= result["properties"]["Availability score"]["number"]
        drafts.push(object)
      end
      cuid_list.each do |cuid|
        availabilities.push({ cuid: cuid, scores: drafts.select{|draft| draft['cuid'] == cuid}.map{|d| d['score']}, username: User.find_by(cid: cuid).username})
      end
    else
      response= DailyReport.get_latest_team_availabilities(cuid_list)
      response["results"].each do |result|
        object= {}
        object['cuid']= result["properties"]["ClickUp User id"]["rich_text"][0]["text"]["content"]
        object['score']= result["properties"]["Availability score"]["number"]
        object['username']= User.find_by(cid: object['cuid']).username
        object['date']= result["properties"]["Register date"]["date"]["start"]

        availabilities.push(object)
      end
      availabilities= availabilities.sort_by{|h| [h['username'], h['date']]}.reverse.uniq!{|h| h['username'] }
    end
    return render json: { availabilities: availabilities}
  end

  def select_team_help_needs
    duration= params['duration'] == '1' ? 'past_week' : 'latest'
    task= Task.find(params['task'])
    cuid_list= task.users.map(&:cid)

    # Notion GET request
    response= ''
    needs= []

    if duration == 'past_week'
      response= DailyReport.get_past_week_team_needs(cuid_list, task.cid)
      drafts = []
      response["results"].each do |result|
        object= {}
        object['cuid']= result["properties"]["ClickUp User id"]["rich_text"][0]["text"]["content"]
        object['score']= result["properties"]["Need help"]["number"]
        object['task_score']= result["properties"]["Task score"]["number"]
        drafts.push(object)
      end
      cuid_list.each do |cuid|
        needs.push({ cuid: cuid, scores: drafts.select{|draft| draft['cuid'] == cuid}.map{|d| d['score']},
                   task_scores: drafts.select{|draft| draft['cuid'] == cuid}.map{|d| d['task_score']}, username: User.find_by(cid: cuid).username})
      end
    else
      response= DailyReport.get_latest_team_needs(cuid_list, task.cid)
      response["results"].each do |result|
        object= {}
        object['cuid']= result["properties"]["ClickUp User id"]["rich_text"][0]["text"]["content"]
        object['score']= result["properties"]["Need help"]["number"]
        object['task_score']= result["properties"]["Task score"]["number"]
        object['username']= User.find_by(cid: object['cuid']).username
        object['date']= result["properties"]["Register date"]["date"]["start"]
        needs.push(object)
      end
      needs= needs.sort_by{|h| [h['username'], h['date']]}.reverse.uniq!{|h| h['username'] }

    end

    return render json: { needs: needs}
  end

  def import_daily_reports
  end

  def import_daily_availabilities
  end
end
