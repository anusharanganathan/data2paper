FactoryGirl.define do

  factory :data_paper do
    title ["Data paper"]
    access_control
    skip_create
    override_new_record
  end

end
