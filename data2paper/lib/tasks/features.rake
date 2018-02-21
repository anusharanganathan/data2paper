namespace :features do
  desc 'Set a hyrax feature, usage: features:set["key1:enabled","key2:enabled","key3:enabled"]  (NB: no spaces!)'
  task :set, [] => :environment do |task, args|
    if (args.extras.present?)
      args.extras.each do |feature|
        key, enabled = feature.split(':')
        if key.present? and enabled.present?
          feature = Hyrax::Feature.where(key: key).first_or_initialize
          feature.update_attributes!(enabled: enabled == 'true')
          puts "#{feature.key} => #{feature.enabled}"
        else
          puts "Warning: ignoring \"#{feature}\""
        end
      end
    else
      abort("ERROR: missing settings, usage: features:set[\"key1:enabled\",\"key2:enabled\",\"key3:enabled\"]")
    end
  end

  desc 'List currently set hyrax features, usage: features:list'
  task :list => :environment do |task|
    Hyrax::Feature.all.each {|feature| puts "#{feature.key} => #{feature.enabled}"}
  end
end
