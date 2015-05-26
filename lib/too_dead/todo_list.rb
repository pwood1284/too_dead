module TooDead
  class TodoList < ActiveRecord::Base
      belongs_to :user
      has_many :items
  end
end
