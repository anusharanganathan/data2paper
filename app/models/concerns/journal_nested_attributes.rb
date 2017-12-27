# accepts_nested_attributes_for can not be called until all the properties are declared
# because it calls resource_class, which finalizes the propery declarations
# See https://github.com/projecthydra/active_fedora/issues/847
module JournalNestedAttributes
  extend ActiveSupport::Concern

  included do
    id_blank = proc { |attributes| attributes[:id].blank? }

    accepts_nested_attributes_for :account, reject_if: :account_blank, allow_destroy: true
    accepts_nested_attributes_for :contact, reject_if: :contact_blank, allow_destroy: true

    # account_blank
    resource_class.send(:define_method, :account_blank) do |attributes|
      Array(attributes[:account_type]).all?(&:blank?) ||
      Array(attributes[:service_format]).all?(&:blank?) ||
      (Array(attributes[:service_key]).all?(&:blank?) &&
      Array(attributes[:service_homepage]).all?(&:blank?)) ||
      Array(attributes[:service_email]).all?(&:blank?)
    end

    # contact_blank - similar to all_blank for defined contact attributes
    resource_class.send(:define_method, :contact_blank) do |attributes|
      contact_attributes.all? do |key|
        Array(attributes[key]).all?(&:blank?)
      end
    end

    resource_class.send(:define_method, :contact_attributes) do
      [:email, :address, :telephone]
    end
  end
end
