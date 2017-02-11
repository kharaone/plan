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

## What's in the box
Plan consists of Makefile, a couple of docker-compose.yml files, and a
collection of Bash scripts.

The Makefile knows when and how to rebuild the docker images and how
to perform the initial setup of the system, for example, during setup
it will link a script, named `plan`, into `/usr/local/bin`. This
script is your interface to your entire development environment.
`plan` provides useful `help` commands (e.g. `plan help kick`) and, if
you're using Zsh, has tab-completions for all commands. To add new
commands to `plan` you simply have to place a bash file in the folder
`scripts/commands` that follows a specific interface (see some of the
other files for examples).

The `presets/*.yml` files are used to specify various subsets of your
services. At [Famly][famly] we have three at the moment: fullstack,
frontend, backend. You can switch between them using the `switch`
command (e.g. `plan switch backend`). We're working on a more granular
way to specify which services to run but haven't found a good solution
yet.

A tool for managing your development environment isn't very useful if
you don't have a couple of services to manage so the repository also
contains a few of services: A small python backend, a small frontend,
and a service that runs migrations whenever a new SQL file is added to
`services/migrations/sql`. These services are merely here as examples
and should be thrown away if you want to use plan for your own
projects (though the migrations service might be useful).

## Goal
The goal we're trying to achieve is to have a 100% automatic way to to
setup and run your entire development stack locally. Once it's running
it should be reacting to code changes automatically. For example, the
Python backend will run the newest code on each request and the
frontend will reload the browser whenever you change any of the files
(Haven't enabled HMR in this example, but feel free to add it). The
migrations container will automatically run migrations when you add
new files and re-run them when they change.

The overall philosophy is that the developer should be able to focus
on the task at hand rather than the mechanics of the developer
environment -- if you can put something in a README it's likely you
can automate it as well 😉

## Requirements
You need to have [Docker][docker] installed. If you're
using [Homebrew][homebrew] simply run the following command.

```bash
brew install docker
```

For tab-completion to work in your shell you need to be
running [Zsh][zsh] for now.

## Installation & Usage
To give it a spin run the following commands in your shell.

```bash
git clone git@github.com:famly/plan && cd plan
make setup
plan up
```

This will build all the Docker images and start the containers. Open
`localhost:8080` in your browser and you should see a little
introduction and a guide.

### Commands
You can always get an overview of the available commands through
tab-completion or by using the `plan help` command.

- **up** Prepare and run the current plan
- **build** Build images if necessary
- **switch `<name>`** Switch to a different plan
- **follow** Follow logs
- **status** Gives a brief overview of the development environment
- **kick `<service>`** Kick a service and hope it helps (sends SIGHUP)
- **attach `<service>`** Start a Bash shell inside the container
- **restart `<service>`** Restart a specific container
- **db `<command>`** Manipulate the database
- **time** Synchronize the Docker VMs time with the host system

To get more information about the specific command run `plan help
<command>`.

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

## FAQ

- **Do I have to use a mono-repo for this to work?** No. We've only
  done it like this here to make the setup a bit more simple. At Famly
  we have one repository, named *famlydev*, for the Makefile, Bash
  scripts and presets. We use the Makefile to clone the relevant
  repositories.


## TODO
- [ ] Listen to SIGTERM for all containers

[famly]: https://famly.co
[famly/plan]: https://github.com/famly/plan
[docker]: https://www.docker.com/
[make]: https://www.gnu.org/software/make/
[bash]: https://www.gnu.org/software/bash/
[zsh]: http://www.zsh.org/
[homebrew]: http://brew.sh/
[blog-post]: http://mads-hartmann.com/2017/01/15/automating-developer-environments.html
[mads]: https://github.com/mads-hartmann
