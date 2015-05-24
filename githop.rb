#!/usr/bin/env ruby

require 'active_support/time'
require 'big_query'
require 'json'

YOUR_GH_USER='neonichu'

def build_query_2014(gh_user)
	end_date = 1.year.ago
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
end

def build_query_2015(gh_user)
	end_date = 1.year.ago
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
end

## Set up some BigQuery stuff, see https://github.com/abronte/BigQuery#keys
## Also take a look at https://www.githubarchive.org/#bigquery
def client_options
	opts = {}
	opts['client_id']     = 'OAuth Client ID'
	opts['service_email'] = 'Service E-Mail'
	opts['key']           = "/path/toprivatekey.p12"
	opts['project_id']    = 'Project ID'
	opts
end

def labels
	{
		'CreateEvent' => 'created the',
		'ForkEvent' => 'forked the repo',
		'IssueCommentEvent' => 'commented an issue on',
		'IssuesEvent' => 'created an issue on',
		'PullRequestEvent' => 'created a PR on',
		'PushEvent' => 'pushed commits to'
	}
end

#######

bq = BigQuery::Client.new(client_options)
query = build_query_2014(YOUR_GH_USER)
result = bq.query(query)

#File.open('bigquery-sample.marshal', 'w') { |to_file| Marshal.dump(result, to_file) }
#result = File.open('bigquery-sample.marshal', 'r') { |from_file| Marshal.load(from_file) }
#exit(0)

result['rows'].map { |row| row['f'] }.each do |event|
	type, owner, repo, created_at = event[0]['v'], event[1]['v'], event[2]['v'], event[3]['v']
	url, desc, ref, ref_type = event[4]['v'], event[5]['v'], event[6]['v'], event[7]['v']

	# Filter some not so interesting events
	if ['IssueCommentEvent', 'IssuesEvent', 'PushEvent'].include?(type)
		next
	end

	action = labels[type]
	raise type if action.nil?

	if type == 'CreateEvent'
		action += " #{ref_type}"
		action += " #{ref} on" if ref_type != 'repository'
	end

	puts "At #{created_at}, you #{action} #{owner}/#{repo}"
end

######
