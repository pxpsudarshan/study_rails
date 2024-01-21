class SpecifiedSkillsController < ApplicationController
  def index

    @SpecifiedIndexData = SpecifiedSkill.all
    @grouped_data = @SpecifiedIndexData.group_by(&:classify_c)

  end
end
