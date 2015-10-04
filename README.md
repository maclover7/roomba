# Roomba

Clean up your project's issue tracker.

# Deploying to Heroku

- Make sure you have the following ENV variables set:
  - ROOMBA_CLOSE_AT: This tells Roomba how long to wait before closing
    an issue. Here are some example times: "14 days", "1 second", etc. If you are famililar with Ruby, this ENV variable needs to be able to have spaces replaced with dots, so that gives you good parameters on what you can specify.
  - ROOMBA_GITHUB_REPO: The repo to be watching. Should be specified
    like this: "maclover7/roomba"
  - ROOMBA_GITHUB_USERNAME: Username of Github user that will be closing
    + commenting on issues.
  - ROOMBA_GITHUB_PASSWORD: Password of Github user that will be closing
    + comment on issues
- Setup a Heroku app with all of the environment variables listed above,
  and then push Roomba up to the app.
- Run `heroku run ./run.sh`
- Add Heroku Scheduler to your app
`heroku addons:create scheduler:standard`
- Go to Heroku Scheduler and enter './run.sh' as the script to be
  running daily.
`heroku addons:open scheduler`
