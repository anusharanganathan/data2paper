namespace :features do
  desc 'Set a hyrax feature, usage: features:set["key","enabled"]'
  task :set, [:key, :enabled] => :environment do |task, args|
    if (args.key.present? && args.enabled.present?)
      feature = Hyrax::Feature.first_or_initialize(key: args.key)
      feature.update_attributes!(enabled: args.enabled == 'true')
      puts "#{feature.key} => #{feature.enabled}"
    else
      abort("ERROR: missing key and enabled")
    end
  end

  desc 'List currently set hyrax features, usage: features:list'
  task :list => :environment do |task|
    Hyrax::Feature.all.each {|feature| puts "#{feature.key} => #{feature.enabled}"}
  end
end
