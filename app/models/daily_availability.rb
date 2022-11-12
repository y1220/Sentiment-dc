class DailyAvailability < ApplicationRecord
    include HTTParty
    base_uri "https://api.notion.com/v1"

    scope :register_to_notion, ->(uid) {where('registered is not true AND user_id = ?',  uid)}

    def self.create_daily_availabilities
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
                        "content": "Daily availabilities"
                    }
                }
            ],
            "properties": {
                "Id": {
                    "title": {}
                },
                "Enable": {
                    "checkbox": {}
                },
                "Availability score": {
                    "number": {}
                },
                "User id": {
                    "number": {}
                },
                "ClickUp User id": {
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
        return nil
    end

    def self.update_daily_availabilities(daily_availabilities_db, da)
        hash= ApplicationRecord.authenticate_notion
        json_body= {
            "parent": {
                "database_id": daily_availabilities_db
            },
            "properties": {
                "Id": {
                    "title": [
                        {
                            "text": {
                                "content": da.id.to_s
                            }
                        }
                    ]
                },
                "Enable": {
                    "checkbox": da.enable
                },
                "Availability score": {
                    "number": da.availability_score
                },
                "User id": {
                    "number": da.user_id
                },
                "ClickUp User id": {
                    "rich_text": [
                        {
                            "text": {
                                "content": User.find(da.user_id).cid
                            }
                        }
                    ]
                },
                "Register date": {
                    "date": {
                        "start": da.register_date,
                        "end": nil,
                        "time_zone": nil
                    }
                },
                "Created at": {
                    "date": {
                        "start": da.created_at,
                        "end": nil,
                        "time_zone": nil
                    }
                },
                 "Updated at": {
                    "date": {
                        "start": da.updated_at,
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
end
