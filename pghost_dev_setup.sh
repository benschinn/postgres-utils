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
|  pane 2 |  pane 3  |
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

# pane 3 connect to local source db
tmux selectp -t 3 
tmux send 'psql' Enter

# pane 2 connec to destination db (docker)
tmux selectp -t 2
tmux send 'docker start yolos-backup' Enter
tmux send 'docker exec -it yolos-backup bash' Enter
tmux send 'su postgres' Enter
tmux send 'psql' Enter
