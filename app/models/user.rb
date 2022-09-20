class User < ActiveRecord::Base
    has_and_belongs_to_many :tasks
    has_and_belongs_to_many :availabilities, after_add: :update_last_status

    enum last_status: { available: 1, normal: 2, busy: 3 }
    enum role: { 'FE developer' => 1, 'BE developer' => 2, 'Fullstack developer'=> 3, 'Data engineer'=> 4 }


    def update_last_status availability
        self.last_status = availability.id
    end
end
