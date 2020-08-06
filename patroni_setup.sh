#!/usr/bin/env sh

printf '
This script assumes the following:

- You have tmux installed and in an active tmux session
- You have patroni installed and set execution of patroni.py aliased as `patroni`.
- You have consul installed
- You have postgres installed


Panes Map:
|--------------------|
|       pane 0       |
|       psql 1       |
|--------------------|
|       pane 1       |
|       psql 2       |
|--------------------|
|       pane 2       |
|       psql 3       |
|--------------------|
|       pane 3       |
|       corvus       |
|--------------------|
|pane 4|pane 5|pane 6|
|node 1|node 2|node 3|
|______|______|______|


Press return when you are ready.
'
read

INITIAL_PANE=$(tmux run 'echo #{pane_id}')

tmux renamew "patroni-consul"

# set up 5 rows
tmux split -p 20
tmux selectp -t $INITIAL_PANE
tmux split -p 26
tmux selectp -t $INITIAL_PANE
tmux split -p 33
tmux selectp -t $INITIAL_PANE
tmux split

# split bottom row into thirds
tmux selectp -t 4
tmux split -h -p 33
tmux selectp -t 4
tmux split -h

# start corvus agent
tmux selectp -t 3
tmux send 'consul agent -dev' Enter

# start primary node0
tmux selectp -t 4
tmux send 'patroni ~/projects/postgres_hunting/configs/node0.yml' Enter

# start primary node1
tmux selectp -t 5
tmux send 'patroni ~/projects/postgres_hunting/configs/node1.yml' Enter

# start primary node2
tmux selectp -t 6 
tmux send 'patroni ~/projects/postgres_hunting/configs/node2.yml' Enter

# connect to postgres0
tmux selectp -t 0
tmux send 'psql -U postgres -p 8432 -h localhost'
# tmux send '\x' Enter
# tmux send 'select * from pg_replication_stat;' Enter

# connect to postgres1
tmux selectp -t 1 
tmux send 'psql -U postgres -p 9432 -h localhost'
# tmux send '\x' Enter
# tmux send 'select * from pg_stat_wal_receiver;' Enter

# connect to postgres2
tmux selectp -t 2 
tmux send 'psql -U postgres -p 7432 -h localhost'
# tmux send '\x' Enter
# tmux send 'select * from pg_stat_wal_receiver;' Enter