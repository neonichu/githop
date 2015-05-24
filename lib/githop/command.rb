require 'active_support/time'

module GitHop
  class Command
    def self.run(other_user, date = 1.year.ago)
      config = YAML.load(File.read("#{ENV['HOME']}/.githop.yml"))
      result = GitHop.hop(config, other_user, date)

      if result['rows'].nil?
        $stderr.puts "GitHub Archive query for #{other_user || config['github_user']} had no results."
        $stderr.puts result.inspect
        exit(1)
      end

      result = GitHop.pretty_print(result, other_user)

      if result.count == 0
        puts "No events found, but #{other_user || 'you'} surely had an awesome day nevertheless :)"
      else
        puts result
      end
    end
  end
end
