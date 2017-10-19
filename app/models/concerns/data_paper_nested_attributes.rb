# accepts_nested_attributes_for can not be called until all the properties are declared
# because it calls resource_class, which finalizes the propery declarations
# See https://github.com/projecthydra/active_fedora/issues/847
module DataPaperNestedAttributes
  extend ActiveSupport::Concern

  included do
    id_blank = proc { |attributes| attributes[:id].blank? }

    accepts_nested_attributes_for :date, reject_if: :date_blank, allow_destroy: true
    accepts_nested_attributes_for :creator_nested, reject_if: :creator_blank, allow_destroy: true
    accepts_nested_attributes_for :relation, reject_if: :relation_blank, allow_destroy: true

    # date_blank
    resource_class.send(:define_method, :date_blank) do |attributes|
      Array(attributes[:date]).all?(&:blank?)
    end

    # creator_blank
    resource_class.send(:define_method, :creator_blank) do |attributes|
      (Array(attributes[:first_name]).all?(&:blank?) &&
      Array(attributes[:last_name]).all?(&:blank?)) ||
      Array(attributes[:role]).all?(&:blank?) ||
      Array(attributes[:orcid]).all?(&:blank?)
    end

    # relation_blank
    # Need label, url / identifier, relationship name / relationship role
    resource_class.send(:define_method, :relation_blank) do |attributes|
      (Array(attributes[:label]).all?(&:blank?) ||
      (Array(attributes[:url]).all?(&:blank?) &&
      Array(attributes[:identifier]).all?(&:blank?))) ||
      (Array(attributes[:relationship_role]).all?(&:blank?) &&
      Array(attributes[:relationship_name]).all?(&:blank?))
    end

    # admin_metadata_blank
    resource_class.send(:define_method, :admin_metadata_blank) do |attributes|
      Array(attributes[:question]).all?(&:blank?)
    end
  end
end
