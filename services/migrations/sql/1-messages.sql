CREATE TABLE IF NOT EXISTS messages (
  id serial primary key,
  message varchar(40) NOT NULL,
  created timestamp default now()
);