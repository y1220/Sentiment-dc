class ReportsController < ApplicationController
  @@user_id = 19 #TODO: for now manipulate directly here to select a user

  def daily
    @create_report_db= PropertySetting.find_by(key_name: "daily_reports_db_id").value_text.present? ? false : true
    @create_availability_db= PropertySetting.find_by(key_name: "daily_availabilities_db_id").value_text.present? ? false : true
    report_link= PropertySetting.find_by(key_name: "daily_reports_link")
    availability_link= PropertySetting.find_by(key_name: "daily_availabilities_link")
    @report_link= report_link ? report_link.value_text : "/reports/daily"
    @availability_link= availability_link ? availability_link.value_text : "/reports/daily"
    @register_dates=DailyAvailability.where(user_id: @@user_id).map(&:register_date)
    @tasks = User.find(@@user_id).active_tasks
    @pending_report= DailyReport.pending
    @pending_availability= DailyAvailability.pending
  end

  def daily_insert
    # POST
    register_date = Date.new(params["Date_of_Birth(1i)"].to_i,params["Date_of_Birth(2i)"].to_i,params["Date_of_Birth(3i)"].to_i)
    params.keys.select{|x| x.start_with?("t")}.each do |task|
      task_score = params[task]
      task_id = task.split(/-/)[1]
      need_help = params["nh-"+task_id.to_s]
      dr = DailyReport.new(user_id: @@user_id, task_id: task_id, cuid: User.find(@@user_id).cid, ct_id: Task.find(task_id).cid, task_score: task_score, need_help: need_help, register_date: register_date)
      begin
        dr.save
      rescue => e
        if e.class.to_s == "ActiveRecord::RecordNotUnique"
          flash[:notice]= "ERROR! :You have already registered for the report of #{register_date.strftime("%d/%m/%Y")}"
        else
          flash[:notice]= "ERROR! :" + e.class.to_s
        end
        break
      end
    end
    en = params["enable"] == "1" ? true : false
    av = en == true ? params["av"] : 0
    da = DailyAvailability.new(user_id: @@user_id, cuid: User.find(@@user_id).cid, enable: en, availability_score: av, register_date: register_date)
    begin
      da.save
      flash[:notice]= "Thanks for your submission :)"
    rescue => e
      if e.class.to_s == "ActiveRecord::RecordNotUnique"
        flash[:notice]= "ERROR! :You have already registered for the report of #{register_date.strftime("%d/%m/%Y")}"
      else
        flash[:notice]= "ERROR! :" + e.class.to_s
      end
    end
    redirect_to action: "daily"
  end

  def create_report_db
    @p= PropertySetting.find_by(key_name: "daily_reports_db_id")
    if @p.value_text.empty?
      response= DailyReport.create_daily_reports
      @p.value_text= response["id"]
      if @p.save
        @p= PropertySetting.find_by(key_name: "daily_reports_db_id")
        PropertySetting.create(company: 'Notion', key_name: 'daily_reports_link', value_text: response["url"])
        flash[:notice]= "create report db successfully done!"
      else
        flash[:notice]= "ERROR! :creating report db failed"
      end
    else
      flash[:notice]= "report db already exist!"
    end
    redirect_to action: "daily"
  end

  def update_daily_reports
    @p= PropertySetting.find_by(key_name: "daily_reports_db_id")
    if @p
      daily_reports_db= @p.value_text
      @cnt= 0
      DailyReport.register_to_notion(@@user_id).each do |dr|
        if !dr.registered
          update_response= DailyReport.update_daily_reports(daily_reports_db, dr)
          if !update_response
            flash[:notice]= "ERROR! :saving db id failed"
            break
          else
            @cnt+= 1
            dr.registered = true
            dr.nid = update_response
            if !dr.save
              flash[:notice]= "ERROR! :updating daily repository instance failed"
              break
            end
          end
        end
      end
      flash[:notice]= "report data(#{@cnt.to_s}) has been correctly inserted into Notion!"
    else
      flash[:notice]= "firstly, please create report db in Notion!"
    end
    redirect_to action: "daily"
  end

  def create_availability_db
    @p= PropertySetting.find_by(key_name: "daily_availabilities_db_id")
    if @p.value_text.empty?
      response= DailyAvailability.create_daily_availabilities
      @p.value_text= response["id"]
      if @p.save
        @p= PropertySetting.find_by(key_name: "daily_availabilities_db_id")
        PropertySetting.create(company: 'Notion', key_name: 'daily_availabilities_link', value_text: response["url"])
        flash[:notice]= "create availability db successfully done!"
      else
        flash[:notice]= "ERROR! :creating availability db failed"
      end
    else
      flash[:notice]= "availability db already exist!"
    end
    redirect_to action: "daily"
  end

  def update_daily_availabilities
    @p= PropertySetting.find_by(key_name: "daily_availabilities_db_id")
    if @p
      daily_availabilities_db= @p.value_text
      @cnt= 0
      DailyAvailability.register_to_notion(@@user_id).each do |da|
        if !da.registered
          update_response= DailyAvailability.update_daily_availabilities(daily_availabilities_db, da)
          if !update_response
            flash[:notice]= "ERROR! :saving db id failed"
            break
          else
            @cnt+= 1
            da.registered = true
            da.nid = update_response
            if !da.save
              flash[:notice]= "ERROR! :updating daily repository instance failed"
              break
            end
          end
        end
      end
      flash[:notice]= "availability data(#{@cnt.to_s}) has been correctly inserted into Notion!"
    else
      flash[:notice]= "firstly, please create availability db in Notion!"
    end
    redirect_to action: "daily"
  end

  private
  def show_error (error_message, return_to_address)
    flash[:notice]= error_message
    render(return_to_address)
  end

end
