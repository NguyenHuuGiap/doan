class TaskDecorator < Draper::Decorator
  delegate_all

  def display_name
    name || (task_master_id.nil? ? "" : TaskMaster.find(task_master_id).name)
  end

  def display_description
    description || (task_master_id.nil? ? "" : TaskMaster.find(task_master_id).description)
  end
end
