require 'active_record'

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.overdue
    Todo.where("due_date < ?", Date.today)
  end

  def self.due_today
    Todo.where("due_date = ?", Date.today)
  end

  def self.due_later
    Todo.where("due_date > ?", Date.today)
  end

  def self.show_list
    puts "My Todo-List"
    puts "\n\nOverdue\n"
    puts overdue.map { |todo| todo.to_displayable_string }

    puts "\n\n Due Today\n"
    puts due_today.map { |todo| todo.to_displayable_string }

    puts "\n\n Due Later\n"
    puts due_later.map { |todo| todo.to_displayable_string }
  end

  def self.add_task(h)
    Todo.create!(todo_text: h[:todo_text], due_date: Date.today + h[:due_in_days], completed: false)
  end

  def self.mark_as_complete(id)
    mark_complete = Todo.find(id)
    mark_complete.completed = true
    mark_complete.save
  end
end
