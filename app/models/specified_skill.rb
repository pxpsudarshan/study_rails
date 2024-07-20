# app/models/SpecifiedSkill.rb
class SpecifiedSkill < ApplicationRecord
  records_with_operator_on :create, :update, :destroy

  # Assuming 'specified_skills' is the table name
  self.table_name = 'specified_skills'

end
