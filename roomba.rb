require 'rubygems'
require 'octokit'

# Check to make sure ENV variables are setup before running
REQURED_VARIABLES = ["ROOMBA_GITHUB_USERNAME", "ROOMBA_GITHUB_PASSWORD"]
REQURED_VARIABLES.each do |var|
  if ENV[var].nil?
    raise ArgumentError, "The #{var} environment variable is not set."
  end
end
