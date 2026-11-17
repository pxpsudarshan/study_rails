# frozen_string_literal: true

module RecordWithOperator
  class Current < ActiveSupport::CurrentAttributes
    attribute :operator, :default_operator
  end

  module Operator
    def operator
      Current.operator || default_operator
    end

    def operator=(value)
      Current.operator = value
    end

    def with_operator(value, &)
      Current.set(operator: value, &)
    end

    private

    def default_operator
      return Current.default_operator if Current.default_operator.present?

      operator_klass = RecordWithOperator.operator_class_name.safe_constantize
      return nil unless operator_klass

      Current.default_operator = operator_klass.order(:created_at).first
    end  
  end
end
