module RecordWithOperator
  def self.config
    @config ||= {
      :operator_class_name => "User",
      :creator_column => "created_by",
      :updater_column => "updated_by",
      :deleter_column => "deleted_by",
      :operator_association_options => {}}
    @config
  end

  def self.operator_class_name
    config[:operator_class_name]
  end

  def self.creator_column
    config[:creator_column]
  end

  def self.updater_column
    config[:updater_column]
  end

  def self.deleter_column
    config[:deleter_column]
  end
end


require 'record_with_operator/operator'
require 'record_with_operator/recorder'
RecordWithOperator.send :extend, RecordWithOperator::Operator
ActiveRecord::Base.send :include,RecordWithOperator::Operator
ActiveRecord::Base.send :include,RecordWithOperator::Recorder

require 'active_record/connection_adapters/abstract/schema_definitions'
ActiveRecord::ConnectionAdapters::TableDefinition.class_eval do
  def operator_stamps(**options)
    options[:null] = false if options[:null].nil?
    column(:created_by, :uuid, **options)
    column(:updated_by, :uuid, **options)
    column(:deleted_by, :uuid)
  end
end