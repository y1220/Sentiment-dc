class CreateJoinTableUsersAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :availabilities do |t|
      # t.index [:user_id, :availability_id]
      # t.index [:availability_id, :user_id]
    end
  end
end
