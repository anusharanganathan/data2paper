FactoryGirl.define do

  factory :file_set do
    access_control
    skip_create
    override_new_record
  end

end
