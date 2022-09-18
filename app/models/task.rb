class Task < ActiveRecord::Base
  include HTTParty
  belongs_to :list
  has_and_belongs_to_many :users

  def self.details id
    base_uri "https://api.themoviedb.org/3/movie/#{id}"
    get("", query: { } ) #パラメタなし
  end
end
