# Stack
TODO: Write an introduction

## Features

- Tab completion. Although it's just for ZSH for now.

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

- *Reload env. variables*: Currently you'd have to restart a container
  witch `stack restart x` if you change your environment variable file
  (e.g. `./environment/local`). This is of course not optimal. It'd be
  a lot nicer if the containers detected the change and acted
  accordingly. One approach to this might be to instead mount the
  environment file and load it in the entrypoint instead and add it to
  the list of files that inotify listens for.
