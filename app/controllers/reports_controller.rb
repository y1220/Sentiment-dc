class ReportsController < ApplicationController
  def daily
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
      if !dr.save
        show_error("Something went wrong..try again!","reports/daily")
      end
    end
    enable = params["enable"] == "1" ? true : false
    av = params["av"]
    da = DailyAvailability.new(user_id: 1, enable: true, availability_score: av, register_date: register_date)
    if !da.save
      show_error("Something went wrong..try again!","reports/daily")
    end
    redirect_to action: "daily"
  end

end
