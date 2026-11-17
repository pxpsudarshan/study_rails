# frozen_string_literal: true

require "record_with_operator/operator"
require "record_with_operator/recorder"

module RecordWithOperator
  module TableDefinitionExtensions
    def operator_stamps(null: false, type: :uuid, **options)
      column(RecordWithOperator.creator_column, type, null: null, **options)
      column(RecordWithOperator.updater_column, type, null: null, **options)
      column(RecordWithOperator.deleter_column, type, **options)
    end
  end

  def self.config
    @config ||= {
      operator_class_name: "User",
      creator_column: "created_by",
      updater_column: "updated_by",
      deleter_column: "deleted_by",
      operator_association_options: {}
    }
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

RecordWithOperator.extend(RecordWithOperator::Operator)

ActiveSupport.on_load(:active_record) do
  include RecordWithOperator::Operator
  include RecordWithOperator::Recorder

  ActiveRecord::ConnectionAdapters::TableDefinition.include(
    RecordWithOperator::TableDefinitionExtensions
  )
end
