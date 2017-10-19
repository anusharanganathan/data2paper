FactoryGirl.define do

  factory :access_control, class: Hydra::AccessControl do
    #visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    #access_rights Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

    skip_create
  end

  factory :list_source, class: ActiveFedora::Aggregation::ListSource do
    skip_create
  end

  factory :relation, class: ActiveTriples::Relation do
    skip_create
  end

  trait :private do
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
  end


end

