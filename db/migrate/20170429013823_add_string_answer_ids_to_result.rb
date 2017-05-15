class AddStringAnswerIdsToResult < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :answer_ids, :string
    remove_reference :results, :answer
  end
end
