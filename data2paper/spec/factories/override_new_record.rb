FactoryGirl.define do
  trait :override_new_record do
    after(:build) do |instance|
      # we need to override the new_record? method; otherwise it will check with via the Fedora API and initiate an HTTP call
      instance.define_singleton_method(:new_record?) do
        true
      end
    end
  end
end

