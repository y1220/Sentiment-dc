class ReportsController < ApplicationController
  def daily
    @register_dates=DailyAvailability.where(user_id:1).map(&:register_date)
    @tasks = User.find(1).tasks
  end

  def daily_insert
    # POST
    register_date = Date.new(params["Date_of_Birth(1i)"].to_i,params["Date_of_Birth(2i)"].to_i,params["Date_of_Birth(3i)"].to_i)
    params.keys.select{|x| x.start_with?("t")}.each do |task|
      task_score = params[task]
      task_id = task.split(/-/)[1]
      need_help = params["nh-"+task_id.to_s]
      dr = DailyReport.new(user_id: 1, task_id: task_id, task_score: task_score, need_help: need_help, register_date: register_date)
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
    av = params["av"]
    da = DailyAvailability.new(user_id: 1, enable: en, availability_score: av, register_date: register_date)
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

  def create_daily_db
    @p= PropertySetting.find_by(key_name: "daily_reports_db_id")
    if @p.value_text.length == 0
      response= DailyReport.create_daily_reports
      @p.value_text= response["id"]
      if @p.save
        @p= PropertySetting.find_by(key_name: "daily_reports_db_id")
        flash[:notice]= "create report db successfully done!"
      else
        flash[:notice]= "ERROR! :creating report db failed"
      end
    end
    flash[:notice]= "report db already exist!"
    redirect_to action: "daily"
  end

  def update_daily_reports
    @p= PropertySetting.find_by(key_name: "daily_reports_db_id")
    if @p
      daily_reports_db= @p.value_text
      user_id= 1 #TODO: after implement login func, replace vakue dynamically
      @cnt= 0
      DailyReport.register_to_notion(user_id).each do |dr|
        if !dr.registered
          update_response= DailyReport.update_daily_reports(daily_reports_db, dr)
          if !update_response
            flash[:notice]= "ERROR! :saving db id failed"
            break
          else
            @cnt+= 1
            dr.registered = true
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
    if @p.value_text.length == 0
      response= DailyReport.create_daily_availabilities
      @p.value_text= response["id"]
      if @p.save
        @p= PropertySetting.find_by(key_name: "daily_availabilities_db_id")
        flash[:notice]= "create availability db successfully done!"
      else
        flash[:notice]= "ERROR! :creating availability db failed"
      end
    end
    flash[:notice]= "availability db already exist!"
    redirect_to action: "daily"
  end

  def update_daily_availabilities #TODO: to be implemented
  end

  private
  def show_error (error_message, return_to_address)
    flash[:notice]= error_message
    render(return_to_address)
  end

end
