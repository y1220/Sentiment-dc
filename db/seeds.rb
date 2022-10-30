# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 1. prepare status
# ['available', 'normal', 'busy'].each do |status|
#     Availability.create(name: status)
# end

# 2. prepare user
# (https://homepage.net/name_generator/)
# {'Sue Welch' => 'FE developer', 'Abigail Henderson' => 'BE developer', 'Ryan Turner' => 'BE developer', 'Dominic Hemmings' => 'Fullstack developer', 'Karen Bell'=> 'FE developer', 'Piers Thomson' => 'Data engineer'}.each do |name, role|
#     User.create(username: name, role: role)
# end

# 3. associate user and status
# 5.times do
#   (1..User.all.count).to_a.each do |x|
#      @user = User.find(x)
#      @user.availabilities << Availability.find(rand(1..3))
#      @user.save
#   end
# end

# 4. prepare tasks
# {'First Task' => 'Awesome task on awesome app', 'Second Task' => 'More tasks on awesome app'}.each do |name, description|
#     Task.create(name: name, description: description)
# end

# 5. associate user and task
# 5.times do
#   (1..User.all.count).to_a.each do |x|
#      @user = User.find(x)
#      @task_ids = Task.all.map(&:id)
#      @user.tasks << Task.find(@task_ids[rand(0..@task_ids.count-1)])
#      @user.save
#   end
# end
