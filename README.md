Snowball
======
[![wercker status](https://app.wercker.com/status/936a68dcdc9c7d2132c392a9fbf17b01/m "wercker status")](https://app.wercker.com/project/bykey/936a68dcdc9c7d2132c392a9fbf17b01)

### System Dependencies
We recommend using [Homebrew](http://brew.sh/) whenever possible.

* Ruby (we recommend [rbenv](http://rbenv.org/))
* [PostgreSQL](https://wiki.postgresql.org/wiki/Homebrew)
* [Heroku Toolbelt](http://toolbelt.heroku.com/)

### Configuration

Configuration of the application is handled by Foreman.

### Database Setup

1. `postgres -D /usr/local/var/postgres`
1. `rake db:create`
1. `rake db:migrate`

### Local Environment Setup

1. `bundle`
1. `ln -s .env.local .env`
1. `foreman s -f Procfile.dev`

Note: If you need to run `rails c` and access environment variables, use `foreman run rails c`.

### Test Suite

We're using Rspec.

`rake spec`

### Deployment Instructions
All deployment to prod is done automatically via CI using a Github hook. Once deployment has been completed a notification will be posted in the engineering Slack room.

| Environment   | Branch    |
| ------------- |:---------:|
| Production    | master    |
| Staging       | *         |

To push a feature branch to staging, use `git push staging ${BRANCH_NAME}:master`.

### Our Git Flow
Our Git Flow is based off of [Scott Chacon's blog post on GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html).
- Anything in the `master` branch is deployable
- To work on something new, create a descriptively named branch off of `master` (ie: `new-oauth2-scopes`)
- Commit to that branch locally and regularly push your work to the same named branch on the server
- When you need feedback or help, or you think the branch is ready for merging, open a [pull request](https://help.github.com/articles/using-pull-requests)
- After someone else has reviewed and signed off on the feature, you can merge it into `master`
- Once it is merged and pushed to `master`, you can and *should* deploy immediately

### Heroku Setup
1. `heroku keys:add`
1. `heroku git:remote -a snowball`

### Copy Production Database
1. `heroku pgbackups:capture`
1. `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $USER -d snowball_development latest.dump`
