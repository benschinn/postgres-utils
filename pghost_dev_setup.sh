#!/usr/bin/env sh

printf '
This script assumes the following:

- You have tmux installed and in an active tmux session
- You have docker installed
- You have postgres installed


Panes Map:

|--------------------|
|  pane 0 |  pane 1  |
|  editor |  shell   |
|--------------------|
|  pane 3 |  pane 4  |
| dest db |  src db  |
|_________|__________|


Press return when you are ready.
'
read

tmux renamew "pghost-dev"

# set up panes
tmux split
tmux split -h
tmux selectp -t 0
tmux split -h

pghost_dir='~/projects/pghost'

tmux send $pghost_dir Enter
tmux selectp -t 0
tmux send $pghost_dir Enter

# pane 4 connect to local source db

# pane 3 connec to destination db (docker)

