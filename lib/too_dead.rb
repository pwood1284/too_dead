$LOAD_PATH.unshift(File.dirname(__FILE__))

require "too_dead/version"
require 'too_dead/init_db'
require 'too_dead/user'
require 'too_dead/todo_list'
require 'too_dead/todo_item'

require 'pry'
require 'vedeu'

module TooDead
  class Menu
    def initialize
      @user = nil
      @todo_list = nil
    end
    def welcome
      puts "\n\n"
      puts "Welcome to TooDead Todo List"
      puts "At any time, you may exit this application by pressing (q) to Quit."
      puts "\n\n"
    end
    def choose_todo_list

      puts "Start a new Todo list (1) or resume an existing Todo list (2)?"
      selection = gets.chomp
      until selection =~ /^[12]$/
        puts "Please choose new todo list (1) or existing todo list (2)."
        selection = gets.chomp
      end
      if selection.to_i == 1
        puts "Create a name for your new Todo List: "
        list_name = gets.chomp
        @user = User.find_or_create_by(todo_lists: selection)
      else
        @user.todo_list_items.where(completed: false).find_each do |list|
          puts "#{list.todo_list_id} => #{list.todo_item}  #{list.due_date}"
      end
        puts "Please choose one of the options: "
        selection = gets.chomp
        until selection =~ /^\d+$/
          puts "Please select one of the options provided: "
          selection = gets.chomp
        end
        @todo_list = TodoList.find(selection)
      end
    end

    def login
      puts "Input your username: "
        username = gets.chomp
        @user = User.find_or_create_by(name: username)
        puts "Hello, #{username}"
    end

    def todolists
      puts "Todo Lists"
      TooDead::User.all.each do |user|
        puts "#{user.name}"
      end
        puts
    end

# binding.pry
    def run
      welcome
      login
      todolists
      choose_todo_list
        while select_another_list?
          choose_todo_list
          @todo_list.select_another_list?
        end
      puts "See you later!"
    end

    def select_another_list?
      puts "Would you like to select another list? (y or n)"
      selection = gets.chomp
      until selection =~ /^[yn]$/i
        puts "You have to choose yes (y) or no (n)."
          selection = gets.chomp
        end
          selection.downcase == 'y'
      end
    end

end

binding.pry
menu = TooDead::Menu.new
menu.run
