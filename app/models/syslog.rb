class Syslog < ActiveRecord::Base
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

end
