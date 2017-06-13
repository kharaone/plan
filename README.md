# famly/plan
[famly/plan][famly/plan] is an example of how you can
use [Docker][docker], [Make][make], and [Bash][bash] to automate your
entire development environment and provide a nice CLI for common
work-flows. It's an open-source version of our internal development
tool at [Famly][famly] called *famlydev*. This repository is meant to
be forked, cloned, and modified in any way you please; it's simply
providing a starting point for you to hack around with. If you've
found a way to improve upon it then feel free to send us a pull
request ❤️

![Screenshot of famly/plan help command](https://s3.eu-central-1.amazonaws.com/opensource.famly.co/plan/readme.png)

If you want to know more about the background
of [famly/plan][famly/plan] and what problems we're trying to solve
then read this [blog post][blog-post] by [@mads-hartmann][mads].

## Overall goal
The goal we're trying to achieve is to have a 100% automatic way to to
setup and run your entire development stack locally. Once it's running
it should be reacting to code and configuration changes automatically.
For example, the Python backend will run the newest code on each
request and the frontend will reload the browser whenever you change
any of the files (Haven't enabled HMR in this example, but feel free
to add it). The migrations container will automatically run migrations
when you add new files and re-run them when they change. If you change
`services/backend/requirements.txt` or
`services/frontend/package.json` the containers will re-install
dependencies and restart their internal processes; the developer
doesn't have to do anything.

The overall philosophy is that the developer should be able to focus
on the task at hand rather than the mechanics of the developer
environment -- if you can put something in a README it's likely you
can automate it as well 😉

## What's in the box
famly/plan consists of Makefile, a couple of docker-compose.yml files, and a
collection of Bash scripts.

The Makefile knows when and how to rebuild the docker images and how
to perform the initial setup of the system, for example, during setup
it will link a script, named `plan`, into `/usr/local/bin`. This
script is your interface to your entire development environment.
`plan` provides useful `help` commands (e.g. `plan help kick`) and, if
you're using Zsh, has tab-completions for all commands. To add new
commands to `plan` you simply have to place a bash script in the folder
`scripts/commands` that follows a specific interface (see some of the
other files for examples) and you're done.

The `presets/*.yml` files are used to specify various subsets of your
services. At [Famly][famly] we have three at the moment: fullstack,
frontend, backend. You can switch between them using the `switch`
command (e.g. `plan switch backend`). We're working on a more granular
way to specify which services to run but haven't found a good solution
yet. `switch` is simply creating a symlink from `docker-compose.yml` to
the specific preset.

A tool for managing your development environment isn't very useful if
you don't have a couple of services to manage so the repository also
contains a few of services: A small python backend, a small frontend,
and a service that runs migrations whenever a new SQL file is added to
`services/migrations/sql`. These services are merely here as examples
and should be thrown away if you want to use plan for your own
projects (though the migrations service might be useful).

## Requirements
You need to have [Docker][docker] installed. If you're
using [Homebrew][homebrew] simply run the following command.

```bash
brew cask install docker
```

For tab-completion to work in your shell you need to be
running [Zsh][zsh] for now.

## Installation & Usage
To give it a spin simply clone and install famly/plan.

```bash
git clone git@github.com:famly/plan && cd plan
make setup
```

You can now use the script `./scripts/plan.sh`, however, to get a nicer
experience we recommend that you install put script in your `$PATH` and
put `./scripts/plan.completions` on your `fpath`. For your convenience
we've created a Make target that does just that.

```bash
make install
```

This will create the following symlinks:

- /usr/local/share/zsh/site-functions/_plan -> ./script/plan.completions
- /usr/local/bin/plan -> ./scripts/plan

Currently the Zsh completions will only work if symlinked like this
somewhere in your `$fpath`; check out [Possible Contributions](#possible-contributions)
if this is unacceptable to you 😉 You can always remove the symlinks again using
`make uninstall`.

Once the script is installed simply run

```bash
# If you haven't started a new terminal session you might need to
# run compinit for Zsh to pickup the new completion script.
plan up
```

This will build all the Docker images and start the containers. Open
`localhost:8080` in your browser and you should see a little
introduction and a guide.

Run `plan help` to see what commands are available. Run `plan kick backend`
to see what happens. Try changing some of the frontend or backend files.
Try changing one of these files `package.json`, `requirements.txt`,
`webpack.config.js`.

## Using famly/plan for your own projects
You'll need to define your own `Dockerfile`s and `watch.sh` scripts
for your services. In order to work nicely with this system it's
important that you follow the same guidelines as the ones in
`./services`. The guidelines for each service are the following:

  - Keep all Docker related files in a sub-folder named docker. This
    means you'll get the Make rules for free that figure out when to
    rebuild images.

  - Keep all source & configuration files out of the `Dockerfile`. The
    images should simply contain the tools that are required to
    install library dependencies, run your code etc. (notice how we
    don't add source files in the services, we mount in the files
    instead)

  - Your `Dockerfile` should use `CMD ["/watch.sh"]` as the default
    command. Your `watch.sh` script should trap SIGTERM signals and
    exit. If you do these two things your services will shutdown
    quickly. See this [blog-post][stop-containers-in-a-hurry] for
    more details.

  - Your `watch.sh` script should trap SIGHUP signals and do a soft
    reboot; that is, kill all processes and start over. This will
    allow your container to respond to the `kick` command. This
    command is nice to have as sometimes when you switch between
    branches with many changes you might end up in situations where
    the container gets confused; in those cases it's nice to be able
    to give it a kick instead of a full restart.

  - Generally follow the structure of the other `watch.sh` scripts.
    Install library dependencies, start your services and keep track
    of their PIDs, block until configuration files changes, then do the
    whole thing over again.

## Possible Contributions
If you'd like to contribute but need some inspiration then take a look
at our wish list. It consists of things we haven't gotten around to
adding yet.

- **Ease of database dumps**: Assuming that your other team members
  use plan as well and everyone is programming locally there might be
  situations where a team-mate has been able to produce a bug. In such
  a case it would be extremely useful to take a snapshot of your plan
  and share that. For now let's start with the database. We imagine
  something like the following

  ```bash
  plan db dump <filename>
  plan db restore <filename>
  ```

- **Reload env. variables**: Currently you'd have to restart a
  container witch `plan restart x` if you change your environment
  variable file (e.g. `./environment/local`). This is of course not
  optimal. It'd be a lot nicer if the containers detected the change
  and acted accordingly. One approach to this might be to instead
  mount the environment file and load it in the entrypoint instead and
  add it to the list of files that inotify listens for.

- **Remove duplication of service declarations**: Currently you have
  to define a `preset/x.yml` file for each combination of services you
  want to run. This currently means you might define a service
  multiple times which is cumbersome and annoying to maintain. It
  would be great if you could just specify a service once and then
  specify which services to run in a different way.

- **Make symlinks optional**: Some users might prefer not to have symlinks
 for the script and Zsh completions. The only thing getting in the way of
 this right now is that `./scripts/plan.completions` needs a way to locate
 the plan directory in order to invoke the appropriate scripts to get their
 completions. One way to solve this would be to introduce a `$PLAN_HOME`
 environment variable and use that if it exists.

## FAQ

- **Do I have to use a mono-repo for this to work?** No. We've only
  done it like this here to make the setup a bit more simple. At Famly
  we have one repository, named *famlydev*, for the Makefile, Bash
  scripts and presets. We use the Makefile to clone the relevant
  repositories.


[famly]: https://famly.co
[famly/plan]: https://github.com/famly/plan
[docker]: https://www.docker.com/
[make]: https://www.gnu.org/software/make/
[bash]: https://www.gnu.org/software/bash/
[zsh]: http://www.zsh.org/
[homebrew]: http://brew.sh/
[blog-post]: http://mads-hartmann.com/2017/01/15/automating-developer-environments.html
[stop-containers-in-a-hurry]: https://serialized.net/2015/05/stopping-docker-containers-in-a-hurry/
[mads]: https://github.com/mads-hartmann
