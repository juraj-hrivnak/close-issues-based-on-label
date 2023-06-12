require 'octokit'

repo = ENV["GITHUB_REPOSITORY"]
label = ENV["LABEL"]
version = ENV["VERSION"]

client = Octokit::Client.new(:access_token => ENV["GITHUB_TOKEN"])
client.auto_paginate = true

open_issues = client.list_issues(repo, { :labels =>  label, :state => 'open'})

open_issues.each do |issue|
  client.add_comment(repo, issue.number, "Fixed in [#{version}](https://github.com/#{repo}/releases/tag/#{version})")
  client.close_issue(repo, issue.number)
  client.remove_label(repo, issue.number, label)
end
