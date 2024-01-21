class AddClassifyCEngToSpecifiedSkills < ActiveRecord::Migration[6.0]
  def change
    add_column :specified_skills, :classify_c_eng, :string

    # Update existing records based on conditions
    SpecifiedSkill.all.each do |record|
      record.update(classify_c_eng: translate_classify_c(record.classify_c))
    end
  end

  private

  def translate_classify_c(classify_c)
    case classify_c
    when 'フロント業務'
      'Reception duties'
    when 'レストランサービス業務'
      'Restaurant Services duties'
    when '企画・広報業務'
      'Planning and Public duties'
    when '安全衛生・その他基礎知識'
      'Safety, Sanitation and Other Fundamental Knowledge'
    when '接客業務'
      'Customer Services duties'
    else
      classify_c # Keep the original value if no match
    end
  end
end
