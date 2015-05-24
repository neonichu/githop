require 'githop/command'
require 'githop/version'

require 'active_support/time'
require 'big_query'
require 'json'
require 'yaml'

module GitHop
  private

  def self.build_query_2014(gh_user, end_date)
    month = end_date.strftime('%Y%m')
    end_date = end_date.strftime('%Y-%m-%d')

    query = <<END
SELECT type, repository_owner, repository_name, created_at, payload_url, payload_desc, payload_ref,
payload_ref_type
FROM ([githubarchive:month.#{month}])
WHERE actor = '#{gh_user}' AND
(created_at LIKE '#{end_date}%')
ORDER BY created_at;
END
    query
  end

  def self.build_query_2015(gh_user, end_date)
    start_date = (end_date - 1.day).strftime('%Y-%m-%d')
    end_date = end_date.strftime('%Y-%m-%d')

    query = <<END
SELECT type, repo.name, created_at,
  JSON_EXTRACT(payload, '$.action') as event,
FROM (TABLE_DATE_RANGE([githubarchive:day.events_],
  TIMESTAMP('#{start_date}'),
  TIMESTAMP('#{end_date}')
))
WHERE actor.login = '#{gh_user}' ORDER BY created_at;
END
    query
  end

  def self.client_options(config)
    opts = {}
    opts['client_id']     = config['bigquery']['client_id']
    opts['service_email'] = config['bigquery']['service_email']
    opts['key']           = config['bigquery']['keyfile']
    opts['project_id']    = config['bigquery']['project_id']
    opts
  end

  def self.hop(config, user = nil, date = 1.year.ago)
    bq = BigQuery::Client.new(client_options(config))
    query = build_query_2014(user || config['github_user'], date)
    result = bq.query(query)

    # File.open('bigquery-sample.marshal', 'w') { |to_file| Marshal.dump(result, to_file) }
    # exit(0)
    # result = File.open('bigquery-sample.marshal', 'r') { |from_file| Marshal.load(from_file) }

    result
  end

  def self.labels
    {
      'CreateEvent' => 'created the',
      'DeleteEvent' => 'deleted the',
      'ForkEvent' => 'forked the repo',
      'IssueCommentEvent' => 'commented an issue on',
      'IssuesEvent' => 'created an issue on',
      'PullRequestEvent' => 'created a PR on',
      'PushEvent' => 'pushed commits to',
      'WatchEvent' => 'watched the repo'
    }
  end

  def self.pretty_print(result, user = nil)
    pushed_repos = []

    result['rows'].map { |row| row['f'] }.map do |event|
      type, owner, repo, created_at = event[0]['v'], event[1]['v'], event[2]['v'], event[3]['v']
      _, _, ref, ref_type = event[4]['v'], event[5]['v'], event[6]['v'], event[7]['v']

      # Filter some not so interesting events
      next if %w(IssueCommentEvent IssuesEvent WatchEvent).include?(type)

      action = labels[type]
      fail "Unsupported event type #{type}" if action.nil?
      target = "#{owner}/#{repo}"

      if type == 'CreateEvent'
        action += " #{ref_type}"
        action += " #{ref} on" if ref_type != 'repository'
      end

      if type == 'DeleteEvent'
        action += " #{ref_type} #{ref} on"
      end

      if type == 'PushEvent'
        next if pushed_repos.include?(target)
        pushed_repos << target
      end

      "At #{created_at}, #{user || 'you'} #{action} #{target}"
    end.compact
  end
end
