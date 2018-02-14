# Overriding changes introduced to the initialize_field method in Hyrax commit 
# https://github.com/samvera/hyrax/commit/89ffdb757a7ae545e303919d2277901237a5fd30
# To solve issue https://github.com/anusharanganathan/data2paper/issues/1
Hyrax::Forms::WorkForm.class_eval do
  def initialize_field(key)
    super unless [:embargo_release_date, :lease_expiration_date].include?(key)
  end
end
