class DailyReport < ApplicationRecord
    include HTTParty
    base_uri "https://api.notion.com/v1"

    scope :register_to_notion, ->(uid) {where('registered is not true AND user_id = ?',  uid)}
    scope :pending, -> {where('registered is not true').count}

    @@user_id = 1


    def self.create_daily_reports
        hash= ApplicationRecord.authenticate_notion
        page_id= PropertySetting.find_by(company: "Notion", key_name: "page_id").value_text
        json_body= {
            "parent": {
                "type": "page_id",
                "page_id": page_id
            },
            "title": [
                {
                    "type": "text",
                    "text": {
                        "content": "Daily reports"
                    }
                }
            ],
            "properties": {
                "Id": {
                    "title": {}
                },
                "Task score": {
                    "number": {}
                },
                "Need help": {
                    "number": {}
                },
                "User id": {
                    "number": {}
                },
                "Task id": {
                    "number": {}
                },
                "ClickUp User id": {
                    "rich_text": {}
                },
                "ClickUp Task id": {
                    "rich_text": {}
                },
                "Register date": {
                    "date": {}
                },
                "Created at": {
                    "created_time": {}
                },
                 "Updated at": {
                    "last_edited_time": {}
                }
            }
        }.to_json
        response= post("/databases/", query: hash[:query], body: json_body, headers: hash[:headers])
        get_response= JSON.parse(response.body)
        if get_response
            return get_response
        end
        return false
    end

    def self.create_scorings
        hash= ApplicationRecord.authenticate_notion
        page_id= PropertySetting.find_by(company: "Notion", key_name: "page_id").value_text
        json_body= {
            "parent": {
                "type": "page_id",
                "page_id": page_id
            },
            "title": [
                {
                    "type": "text",
                    "text": {
                        "content": "Task scorings",
                        "link": nil
                    }
                }
            ],
            "properties": {
                "Id": {
                    "title": {}
                },
                "ClickUp Task id": {
                    "rich_text": {}
                },
                "Adjusted by": {
                    "rich_text": {}
                },
                "Complexity": {
                    "number": {}
                },
                "Priority": {
                    "number": {}
                },
                "Duration": {
                    "number": {}
                },
                "Front-end": {
                    "number": {}
                },
                "Back-end": {
                    "number": {}
                },
                "Infrastructure": {
                    "number": {}
                },
                "Data-manipulation": {
                    "number": {}
                },
                "Created at": {
                    "created_time": {}
                },
                 "Updated at": {
                    "last_edited_time": {}
                }
            }
        }.to_json
        response= post("/databases/", query: hash[:query], body: json_body, headers: hash[:headers])
        get_response= JSON.parse(response.body)
        if get_response
            return get_response
        end
        return false
    end

    def self.update_scorings(scorings_db, task)
        hash= ApplicationRecord.authenticate_notion
        scorings_db_id= PropertySetting.find_by(company: "Notion", key_name: "scorings_db_id").value_text
        json_body= {
            "parent": {
                "database_id": scorings_db_id
            },
            "properties": {
                "ClickUp Task id": {
                    "rich_text": [
                        {
                            "text": {
                                "content": task.cid
                            }
                        }
                    ]
                },
                "Adjusted by": {
                    "rich_text": [
                        {
                            "text": {
                                "content": User.find(@@user_id).cid
                            }
                        }
                    ]
                },
                "Complexity": {
                    "number": task.complexity_score
                },
                "Priority": {
                    "number": task.priority_score
                },
                "Duration": {
                    "number": task.duration_score
                },
                "Front-end": {
                    "number": task.frontend_score
                },
                "Back-end": {
                    "number": task.backend_score
                },
                "Infrastructure": {
                    "number": task.infrastructure_score
                },
                "Data-manipulation": {
                    "number": task.data_manipulation_score
                },
                "Created at": {
                    "date": {
                        "start": task.created_at,
                        "end": nil,
                        "time_zone": nil
                    }
                },
                 "Updated at": {
                    "date": {
                        "start": task.updated_at,
                        "end": nil,
                        "time_zone": nil
                    }
                }
            }
        }.to_json
        response= post("/pages/", query: hash[:query], body: json_body, headers: hash[:headers])
        post_response= JSON.parse(response.body)
        if post_response
           return post_response['id']
        end
        return false
    end

    def self.update_daily_reports(daily_reports_db, dr)
        hash= ApplicationRecord.authenticate_notion
        json_body= {
            "parent": {
                "database_id": daily_reports_db
            },
            "properties": {
                "Id": {
                    "title": [
                        {
                            "text": {
                                "content": dr.id.to_s
                            }
                        }
                    ]
                },
                "Task score": {
                    "number": dr.task_score
                },
                "Need help": {
                    "number": dr.need_help
                },
                "User id": {
                    "number": dr.user_id
                },
                "Task id": {
                    "number": dr.task_id
                },
                "ClickUp User id": {
                    "rich_text": [
                        {
                            "text": {
                                "content": dr.cuid ? dr.cuid : User.find(dr.user_id).cid
                            }
                        }
                    ]
                },
                "ClickUp Task id": {
                    "rich_text": [
                        {
                            "text": {
                                "content": dr.ct_id ? dr.ct_id : Task.find(dr.task_id).cid
                            }
                        }
                    ]
                },
                "Register date": {
                    "date": {
                        "start": dr.register_date,
                        "end": nil,
                        "time_zone": nil
                    }
                },
                "Created at": {
                    "date": {
                        "start": dr.created_at,
                        "end": nil,
                        "time_zone": nil
                    }
                },
                 "Updated at": {
                    "date": {
                        "start": dr.updated_at,
                        "end": nil,
                        "time_zone": nil
                    }
                }
            }
        }.to_json
        response= post("/pages/", query: hash[:query], body: json_body, headers: hash[:headers])
        post_response= JSON.parse(response.body)
        if post_response
            return post_response['id']
        end
        return false
    end

    def self.get_past_week_team_availabilities(cuid_list)
        hash= ApplicationRecord.authenticate_notion
        report_db= PropertySetting.find_by(company: "Notion", key_name: "daily_availabilities_db_id").value_text
        list= []
        cuid_list.each do |cuid|
            list.push({
                "property": "ClickUp User id",
                "rich_text": {
                    "equals": cuid
                }
            })
        end
        json_body= {
            "filter": {
                "and": [
                            {
                                "property": "Register date",
                                    "date": {
                                        "past_week": {}
                                    }
                            },
                            {
                            "or": list
                            }
                ]
            }
        }.to_json
        response= post("/databases/#{report_db}/query", query: hash[:query], body: json_body, headers: hash[:headers])
        get_response= JSON.parse(response.body)
        if get_response
            return get_response
        end
        return false
    end

    def self.get_past_week_team_needs(cuid_list, ct_id)
        hash= ApplicationRecord.authenticate_notion
        report_db= PropertySetting.find_by(company: "Notion", key_name: "daily_reports_db_id").value_text
        list= []
        cuid_list.each do |cuid|
            list.push({
                "property": "ClickUp User id",
                "rich_text": {
                    "equals": cuid
                }
            })
        end
        json_body= {
            "filter": {
                "and": [
                            {
                                "property": "Register date",
                                    "date": {
                                        "past_week": {}
                                    }
                            },
                            {
                            "or": list
                            },
                            {
                                "property": "ClickUp Task id",
                                    "rich_text": {
                                        "equals": ct_id
                                    }
                            }
                ]
            }
        }.to_json
        response= post("/databases/#{report_db}/query", query: hash[:query], body: json_body, headers: hash[:headers])
        get_response= JSON.parse(response.body)
        if get_response
            return get_response
        end
        return false
    end

    def self.get_latest_team_availabilities(cuid_list)
        hash= ApplicationRecord.authenticate_notion
        report_db= PropertySetting.find_by(company: "Notion", key_name: "daily_availabilities_db_id").value_text
        list= []
        cuid_list.each do |cuid|
            list.push({
                "property": "ClickUp User id",
                "rich_text": {
                    "equals": cuid
                }
            })
        end
        json_body= {
            "filter": {
                "and": [
                            {
                                "property": "Register date",
                                    "date": {
                                        "on_or_after": 5.days.ago.strftime('%Y-%m-%d')
                                    }
                            },
                            {
                            "or": list
                            }
                ]
            }
        }.to_json
        response= post("/databases/#{report_db}/query", query: hash[:query], body: json_body, headers: hash[:headers])
        get_response= JSON.parse(response.body)
        if get_response
            return get_response
        end
        return false
    end

    def self.get_latest_team_needs(cuid_list, ct_id)
        hash= ApplicationRecord.authenticate_notion
        report_db= PropertySetting.find_by(company: "Notion", key_name: "daily_reports_db_id").value_text
        list= []
        cuid_list.each do |cuid|
            list.push({
                "property": "ClickUp User id",
                "rich_text": {
                    "equals": cuid
                }
            })
        end
        json_body= {
            "filter": {
                "and": [
                            {
                                "property": "Register date",
                                    "date": {
                                        "on_or_after": 5.days.ago.strftime('%Y-%m-%d')
                                    }
                            },
                            {
                            "or": list
                            },
                            {
                                "property": "ClickUp Task id",
                                    "rich_text": {
                                        "equals": ct_id
                                    }
                            }
                ]
            }
        }.to_json
        response= post("/databases/#{report_db}/query", query: hash[:query], body: json_body, headers: hash[:headers])
        get_response= JSON.parse(response.body)
        if get_response
            return get_response
        end
        return false
    end

    def self.update
        # response = Task.details
        # @task_info = response['tasks']
        # @task_info.each do |task|
        # flag = 0
        # t_created= Time.at(task['date_created'][0..9].to_i)
        # dd_created = DateTime.parse(t_created.to_s)
        # item= Item.where(cid: item['id']).first
        #             @item.name = item['name']
        #             @item.resolved = item['resolved']
        #             @item.user_id = item['assignee'] ? User.where(cid: item['assignee']['id']).first.id : User.all.first.id #need to be fixed to allow it as optional
        #         end
        #         if !@item.save
        #             return false, "Error: Item saving failed"
        #         end
        #         end
        #     end
        #     end
        # end
        # end
    end
end
