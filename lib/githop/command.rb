require 'active_support/time'

module GitHop
  class Command
    def self.run(other_user, date = 1.year.ago)
      config = YAML.load(File.read("#{ENV['HOME']}/.githop.yml"))
      result = GitHop.hop(config, other_user, date)
      result = GitHop.pretty_print(result, other_user) unless result['rows'].nil?

      if result.is_a?(Array) && result.count > 0
        puts result
      else
        puts "No events found, but #{other_user || 'you'} surely had an awesome day nevertheless :)"
      end
    end
  end
end
