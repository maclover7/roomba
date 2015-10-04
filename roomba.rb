require 'octokit'
require 'active_support/time'

# Check to make sure ENV variables are setup before running
REQURED_VARIABLES = ['ROOMBA_GITHUB_REPO', 'ROOMBA_GITHUB_USERNAME', 'ROOMBA_GITHUB_PASSWORD']
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
  last_comment_updated_at_string = comments.last[:updated_at].to_s
  last_comment_updated_at_time = Time.parse(last_comment_updated_at_string)
  if last_comment_updated_at_time < 14.days.ago
  end
end
