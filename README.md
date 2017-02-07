# Stack
This is an open-source verison of our internal development tool *famlydev*. This
repository is meant to be forked, cloned, and modified in any way you please; it's
simply providing a starting point for you to hack around with. If you've found a
way to improve upon it then feel free to send a pull request ❤️

If you want to know more about the background of *famlydev* and what problems
we're trying to solve then head this [blog post][blogpost] by [@mads-hartmann][mads].

To give it a spin run the following commands in your shell

```bash
git clone git@github.com:famly/stack && cd stack
make setup
stack up
```

This will build all the Docker images and then start the containers. Open
`localhost:8080`  in your browser and you should see a little introduction
and a guide on how to create your first migration.

To see what else stack can do run `stack help`.

## Features

- Tab completion. Although it's just for ZSH for now.

## Commands

## Services
The services inside of `./services/` are simply small proof's of concepts. Here's a short
description of each service

- **migrations**: This service applies SQL migration to the MySQL instance. When running in
  development mode it will re-apply migrations if they've changed.

- **backend**: A tiny Python backend that reads from the MySQL database.

- **frontend**: A tiny React based frontend that's built using Webpack 2. It quires the backend
  for data.

## Requirements
You need to have [Docker][docker] installed.

```bash
brew install docker
```

For tab-completion to work in your shell you need to be running [Zsh][zsh]
for now.

**TODO**: I think you need to have something in your zsh config for completion functions
to be called. We should figure out what and add it here.

## Contribute
If you'd like to contribute but need some inspiration then take a look
at our wish list. It consists of things we haven't gotten around to
adding yet.

- **Ease of database dumps**: Assuming that your other team members
  use stack as well and everyone is programming locally there might be
  situations where a team-mate has been able to produce a bug. In such
  a case it would be extremely useful to take a snapshot of your stack
  and share that. For now let's start with the database. We imagine
  something like the following

  ```bash
  stack db dump <filename>
  stack db restore <filename>
  ```

- **Reload env. variables**: Currently you'd have to restart a container
  witch `stack restart x` if you change your environment variable file
  (e.g. `./environment/local`). This is of course not optimal. It'd be
  a lot nicer if the containers detected the change and acted
  accordingly. One approach to this might be to instead mount the
  environment file and load it in the entrypoint instead and add it to
  the list of files that inotify listens for.

## TODO
- [x] Create a backend service. Node is probably easiest.
- [x] Hook frontend up with the backend
- [x] Figure out why ZSH completions no longer work.
- [ ] Port over missing command
      - [ ] db
      - [ ] dockerclean (or similar)
      - [ ] time
      - [ ] update?
- [x] Port over environment variables file
- [x] Add a ln -s from docker-compose.yml -> presets/fullstack.yml to git. then add docker-compose.yml to .gitignore
- [ ] Switch everything to be named stack.
- [ ] Finish the help command of stack.
- [ ] Write introduction README

[docker]: https://www.docker.com/
[zsh]: http://www.zsh.org/
[blogpost]: http://mads-hartmann.com/2017/01/15/automating-developer-environments.html
[mads]: https://github.com/mads-hartmann