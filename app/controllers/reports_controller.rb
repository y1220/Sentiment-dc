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
    byebug
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

  private
  def show_error (error_message, return_to_address)
    flash[:notice]= error_message
    render(return_to_address)
  end

end
