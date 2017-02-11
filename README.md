# Famly/plan
[famly/plan][famly/plan] is an example of how you can use [Docker][docker], [Make][make], and
[Bash][bash] to automate your entire development environment and provide a
nice CLI for common workflows. It's an open-source verison of our internal
development tool at [Famly][famly] called *famlydev*. This repository is meant to be forked,
cloned, and modified in any way you please; it's simply providing a starting point for you to
hack around with. If you've found a way to improve upon it then feel free to send
us a pull request ❤️

If you want to know more about the background of *famlydev* and what problems
we're trying to solve then read this [blog post][blogpost] by [@mads-hartmann][mads].

## What's in the box
Plan consists of Makefile, a couple of docker-compose.yml files, and a collection of
Bash scripts.

The Makefile knows when and how to rebuild the docker images and how to perform the initial setup of the system, for example, during setup it will link a script,
named `plan`, into `/usr/local/bin`. This script is your interface to your entire
development environment. `plan` provides useful `help` commands (e.g. `plan help kick`) and,
if you're using Zsh, has tab-completions for all commands. To add new commands to `plan`
you simply have to place a bash file in the folder `scripts/commands` that follows a
specific interface (see some of the other files for examples).

The `presets/*.yml` files are used to specify various subsets of your
services. At [Famly][famly] we have three at the moment: fullstack, frontend, backend.
You can switch between them using the `switch` command (e.g. `plan switch frontend`). We're
working on a more granular way to specify which services to run but haven't found a good
solution yet.

A tool for managing your development environment isn't very useful if you don't have a
couple of services to manage so the repository also contains a few of servies: A small
python backend, a small frontend, and a service that runs migrations whenever a new SQL file
is added to `services/migrations/sql`. These services are merely here as examples and should
be thrown away if you want to use plan for your own projects (though the migrations service might be useful).

## Requirements
You need to have [Docker][docker] installed. If you're using [Homebrew][homebrew] simply run
the following command. Otherwise look [here][docker-install-instructions]

```bash
brew install docker
```

For tab-completion to work in your shell you need to be running [Zsh][zsh]
for now.

## Installation & Usage
To give it a spin run the following commands in your shell.

```bash
git clone git@github.com:famly/plan && cd plan
make setup
plan up
```

This will build all the Docker images and start the containers. Open
`localhost:8080` in your browser and you should see a little introduction
and a guide.

To see what else plan can do run `plan help`.

### Commands

## Contribute
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

- **Reload env. variables**: Currently you'd have to restart a container
  witch `plan restart x` if you change your environment variable file
  (e.g. `./environment/local`). This is of course not optimal. It'd be
  a lot nicer if the containers detected the change and acted
  accordingly. One approach to this might be to instead mount the
  environment file and load it in the entrypoint instead and add it to
  the list of files that inotify listens for.

## FAQ

- **How is this different from using docker-compose directly**


## TODO
- [ ] Write introduction README
  - [ ] Add a screenshot
- [ ] Listen to SIGTERM for all containers

[famly]: https://famly.co
[famly/plan]: https://github.com/famly/plan
[docker]: https://www.docker.com/
[make]: https://www.gnu.org/software/make/
[bash]: https://www.gnu.org/software/bash/
[zsh]: http://www.zsh.org/
[blogpost]: http://mads-hartmann.com/2017/01/15/automating-developer-environments.html
[mads]: https://github.com/mads-hartmann
