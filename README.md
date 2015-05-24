# githop

🐙⏰

Uses [BigQuery][3] and [GitHub Archive][2] to create something like [TimeHop][4] for GitHub. It will
show you the things you did exactly one year ago.

## Usage

If you are orta and it is 24th of May, 2015, you might see something like this:

```bash
$ ./githop.rb 
At 2014-05-24 11:54:54, you forked the repo cocodelabs/NSAttributedString-CCLFormat
At 2014-05-24 11:56:49, you created a PR on cocodelabs/NSAttributedString-CCLFormat
At 2014-05-24 22:03:42, you created a PR on CocoaPods/cocoadocs.org
At 2014-05-24 22:32:20, you created the tag 2.7.2 on orta/ARAnalytics
```

## Installation

Use

```bash
bundle install
```

to install the dependencies and configure some settings in `~/.githop.yml`:

```yaml
---
github_user: your GitHub username

bigquery: {
	client_id: BigQuery OAuth Client-ID,
	service_email: BigQuery Service E-Mail,
	keyfile: Location of your BigQuery key (a .p12 file),
	project_id: ID of your BigQuery project
}
```

Please follow [these steps][5] to set up a [BigQuery][3] OAuth application and take a look at 
[this][6] for manually verifying your Google Cloud account works. [BigQuery][3] is free for 3TB
of queries and you don't have to set up any payments to use GitHop.

## Thanks

Felix Krause for the [idea][1].

[1]: https://twitter.com/KrauseFx/status/602506804547977216
[2]: https://www.githubarchive.org/
[3]: https://cloud.google.com/bigquery/what-is-bigquery
[4]: http://timehop.com
[5]: https://github.com/abronte/BigQuery#keys
[6]: https://www.githubarchive.org/#bigquery
