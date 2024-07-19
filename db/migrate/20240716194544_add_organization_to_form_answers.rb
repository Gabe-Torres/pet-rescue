class AddOrganizationToFormAnswers < ActiveRecord::Migration[7.1]
  def change
    add_reference :form_answers, :organization, null: false, foreign_key: true
  end
end