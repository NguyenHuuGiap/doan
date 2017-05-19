class UpdateUserChartsService

  def initialize user, company
    @group = group
    @groups = company.groups
    @result_msg = Array.new
    @updated_counter = 0
  end

  def build_group node_data
    Group.transaction do
      node_data.each do |_index, object|
        group = @groups.detect{|group| group.id == object[:key].to_i}
        update_group(group, object) if group
      end
    end
  end

  def delete_group
    Group.transaction do
      @group_children = @group.children.of_closest_parent_id @group.id
      if @group.closest_parent_id
        @group_children.update closest_parent_id: @group.closest_parent_id
        unless @group_children.any?{|a| a.valid?}
          raise ActiveRecord::Rollback if @group_children.present?
        end
      else
        @group_children.update closest_parent_id: nil
        unless @group_children.any?{|a| a.valid?}
          raise ActiveRecord::Rollback if @group_children.present?
        end
      end
      @group.children.each do |group_parent|
        group_parent.parent_path.delete @group.id
        group_parent.update parent_path: group_parent.parent_path
        if group_parent.present? && group_parent.invalid?
          raise ActiveRecord::Rollback
        end
      end
      @group.destroy
    end
  end

  def get_build_results
    {msg: @result_msg, counter: @updated_counter}
  end

  private

  def update_group group, object
    if group.update group_params object
      @updated_counter += 1
    else
      @result_msg.push I18n.t("dashboard.workspaces.update.errors", key: object[:key])
    end
  end

  def group_params object
    {
      closest_parent_id: object[:parent],
      parent_path: parent_path_group(object)
    }
  end

  def parent_path_group object
    group_parent = Group.find_by id: object[:parent]
    return [] unless group_parent
    group_parent.parent_path << object[:parent].to_i
  end
end
