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

to install the dependencies. The rest is quite manual at the moment, you have to add your [BigQuery][3]
credentials to `githop.rb` and also change the `YOUR_GH_USER` variable in that script.

## Thanks

Felix Krause for the [idea][1].

[1]: https://twitter.com/KrauseFx/status/602506804547977216
[2]: https://www.githubarchive.org/
[3]: https://cloud.google.com/bigquery/what-is-bigquery
[4]: http://timehop.com
