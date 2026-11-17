# frozen_string_literal: true

module RecordWithOperator
  module Recorder
    extend ActiveSupport::Concern

    private

    def set_creator
      col = RecordWithOperator.creator_column
      public_send("#{col}=", operator&.id) if public_send(col).blank?
    end

    def set_updater
      return unless changed?

      col = RecordWithOperator.updater_column
      return if new_record? && public_send(col).present?
      return unless operator

      public_send("#{col}=", operator.id)
    end

    def update_deleter
      return if frozen?
      return unless operator

      deleter_col = RecordWithOperator.deleter_column
      public_send("#{deleter_col}=", operator.id)

      if persisted? && self.class.respond_to?(:paranoid?) && self.class.paranoid?
        update_column(deleter_col, operator.id)
      end
    end

    def clear_deleter
      deleter_col = RecordWithOperator.deleter_column
      public_send("#{deleter_col}=", nil)
    end

    class_methods do
      VALID_ACTIONS = %w[create update destroy].freeze

      def records_with_operator_on(*args)
        actions = args.map(&:to_s)
        unless actions.all? { |arg| VALID_ACTIONS.include?(arg) }
          raise ArgumentError, "Valid actions are #{VALID_ACTIONS.inspect}."
        end

        @records_on = actions

        define_operator_callbacks
        define_operator_associations
      end

      def records_creator?
        @records_on&.include?("create") || false
      end

      def records_updater?
        @records_on&.include?("update") || false
      end

      def records_deleter?
        @records_on&.include?("destroy") || false
      end

      private

      def define_operator_callbacks
        before_validation :set_creator, on: :create if records_creator?
        before_validation :set_updater if records_updater?

        if records_deleter?
          before_destroy :update_deleter
          before_recover :clear_deleter if respond_to?(:before_recover)
        end
      end

      def define_operator_associations
        base_options = {
          class_name: RecordWithOperator.operator_class_name
        }.merge(RecordWithOperator.config[:operator_association_options]).merge(optional: true)

        if records_creator?
          belongs_to :creator, **base_options, foreign_key: RecordWithOperator.creator_column
          validates RecordWithOperator.creator_column, presence: true
        end

        if records_updater?
          belongs_to :updater, **base_options, foreign_key: RecordWithOperator.updater_column
          validates RecordWithOperator.updater_column, presence: true
        end

        if records_deleter?
          belongs_to :deleter, **base_options, foreign_key: RecordWithOperator.deleter_column
        end
      end
    end
  end
end
