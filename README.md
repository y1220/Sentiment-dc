# Project description

Aiming for making a platform for software developers to visualize their task statuses,<br/>
objective goal is to improve the approachability of collaboration inside of teams.<br/>
By selecting characteristics of the task, it searches similar tasks from the history and it provides you with a description about the task, commit history.<br/>
It utilises GitHub API, ClickUp API, information can be fetched or updated via our UI.<br/>
Also, by storing information about daily task status and your availability to help teammates,<br/>
it suggests to whom you need to help, to whom you can ask help if you need.<br/>

Future focuses are to implement the ML algorithms to obtain the analysis functionarities below.<br/>

* evaluation of the task characteristics
* list up the skill set, seniority of developers
* help matching based on needs, skills
* similarity calculation of tasks
* counting the visits of forum content, eventually used for analysis of content preferences, seniority level of developer
* comparison of time used depends on week/month wise according to the needs
* utilize Notion API to store and share the updated data among the team<br/>
[tutorial of Notion API - databases](https://developers.notion.com/reference/database)

## Ruby version

2.5

## Prerequisites (Linux)

sudo chown -R 5050:5050 *<PGADMIN_VOLUME_HOSTPATH>*


## Utilities Scripts (Linux)

Check the .local folder in the project root. It contains utilities scripts in order to develop and setup your local environment.

## Docker command for setup

docker-compose up -d<br/>
docker-compose exec web bash<br/>
bundle install<br/>
rails db:create<br/>
rails db:migrate<br/>

## Docker command for running server

rails s -b 0.0.0.0

## Database creation

(option 1): run a seed file
rails db:seed

(option 2): operate from console
rails c
Model.create(name: 'something'...)

## Database management

[tutorial for connecting to pgadmin](https://www.youtube.com/watch?v=2BjrT14Heug)

## Test

To be implemented in near future
