FactoryGirl.define do

  factory :journal do
    title ["Journal"]
    access_control
    skip_create
    override_new_record
  end

end
