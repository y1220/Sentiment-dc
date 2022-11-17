class DailyReport < ApplicationRecord
    include HTTParty
    base_uri "https://api.notion.com/v1"

    scope :register_to_notion, ->(uid) {where('registered is not true AND user_id = ?',  uid)}
    scope :pending, -> {where('registered is not true').count}

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
                                        "on_or_after": Date.yesterday.strftime('%Y-%m-%d')
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
                                        "on_or_after": Date.yesterday.strftime('%Y-%m-%d')
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
