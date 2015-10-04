require 'octokit'
require 'active_support/core_ext/string/strip'
require 'active_support/time'

# Check to make sure ENV variables are setup before running
REQURED_VARIABLES = ['ROOMBA_CLOSE_AT', 'ROOMBA_GITHUB_REPO', 'ROOMBA_GITHUB_USERNAME', 'ROOMBA_GITHUB_PASSWORD']
REQURED_VARIABLES.each do |var|
  if ENV[var].nil?
    raise ArgumentError, "The #{var} environment variable is not set."
  end
end

# Get all of the repo's currently open issues
OCTOKIT_CLIENT = Octokit::Client.new(
  login: ENV['ROOMBA_GITHUB_USERNAME'],
  password: ENV['ROOMBA_GITHUB_PASSWORD']
)

# Retreive all open issues for the given repo.
issues = OCTOKIT_CLIENT.issues(
  ENV['ROOMBA_GITHUB_REPO'],
  state: "open"
)

# Get a list of all of the numbers of open issues for the given repo.
issue_numbers = issues.each.map(&:number)

# Get a list of all comments for each open issue, then check if the most recent (last) comment
# was made before a certain time. If so, comment and close the issue.
issue_numbers.each do |issue_number|
  comments = OCTOKIT_CLIENT.issue_comments(ENV['ROOMBA_GITHUB_REPO'], issue_number)

  if comments && !comments.empty?
    # Get last comment's updated_at time. Represents last time issue was looked at.
    last_updated_at_string = comments.last[:updated_at].to_s
    last_updated_at_time = Time.parse(last_updated_at_string)
  else
    # Get the actual issue's updated_at time. Represents last time issue was looked at.
    issue = OCTOKIT_CLIENT.issue(ENV['ROOMBA_GITHUB_REPO'], issue_number)
    last_updated_at_string = issue[:updated_at].to_s
    last_updated_at_time = Time.parse(last_updated_at_string)
  end

  # Parse ENV['ROOMBA_CLOSE_AT'], and eval to transform from String to Time.
  close_at_time = eval(ENV['ROOMBA_CLOSE_AT'].sub(' ', '.') + ".ago")
  if last_updated_at_time < close_at_time
    message = <<-content.strip_heredoc
      Hey there!
      We're automatically closing this issue since the original poster (or another commenter) hasn't yet responded to the question or request made to them #{ENV['ROOMBA_CLOSE_AT']} ago. We therefore assume that the user has lost interest or resolved the problem on their own. Closed issues that remain inactive for a long period may get automatically locked.
      Don't worry though; if this is in error, let us know with a comment and we'll be happy to reopen the issue.
      Thanks!
      (*Please note that this is an [automated](https://github.com/maclover7/roomba) comment.*)
    content
    OCTOKIT_CLIENT.add_comment(ENV['ROOMBA_GITHUB_REPO'], issue_number, message)
    OCTOKIT_CLIENT.close_issue(ENV['ROOMBA_GITHUB_REPO'], issue_number)
    puts "Closed and commented on #{ENV['ROOMBA_GITHUB_REPO']}##{issue_number}."
  end
end
