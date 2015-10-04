require 'rubygems'
require 'octokit'

# Check to make sure ENV variables are setup before running
REQURED_VARIABLES = ['ROOMBA_GITHUB_USERNAME', 'ROOMBA_GITHUB_PASSWORD']
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

# require 'pry'; binding.pry
