class Repository < ApplicationRecord
    has_many :repositories_users
    has_many :users, through: :repositories_users
    has_many :branches
    has_many :tasks


    include HTTParty
    base_uri "https://api.github.com/repos"

    def self.contributors(repo_id)
        hash= ApplicationRecord.authenticate_gitHub
        repo = Repository.find(repo_id)
        username= repo.owner
        repo_name= repo.title
        response = get("/#{username}/#{repo_name}/contributors", query: hash[:query], headers: hash[:headers])
        JSON.parse(response.body)
    end

    def format_created_at
        self.created_at.present? ? self.created_at.strftime('%m-%d-%Y %l:%M %p') : nil
    end

    def format_updated_at
        self.updated_at.present? ? self.updated_at.strftime('%m-%d-%Y %l:%M %p') : nil
    end
end
