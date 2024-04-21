# Tmux


## Keybinds

- Ctrl + a : `leader` key

- leader + s: list sessions
- leader + d: detach from session
- leader + ( :  move to previous session
- leader + ) : move to next session 
- leader + $: rename session

- leader + c : create a windows
- leader + , : rename current window
- leader + & : close current window
- leader + w : session and preview window
- leader + p : move to previous window
- leader + n : move to next window
- leader + [0...9] : move to window number

- leader + -:  split pane horizontal
- leader + |:  split pane vertical
- leader + (h, j, k, l): resize pane in direction left,down, up and right

- leader + ':': 
    - new : create a new session
    - new -s ${session-name}: create a new session with session-name
    - attach -d: detach others on the session

    - swap-window -s 2 -t 1: reorder window, swap window number 2(src) to 1(dst)
    - swap-window -t 1: move current window to the left by one position
    - movew -s 0:0 -t 1:9: move window from source to target
    - movew -s 0:9: reposition windows in the current session



## Commands

- tmux | tmux new | tmux new-session: create a new session 
- tmux new -s ${session-name}: create a new session with name 
- tmux ls | tmux list-sessions: list all session opens in tmux
- tmux a | tmux attach | tmux at |  tmux attach-session: attach to previous session
- tmux a -t | tmux attach -t ${example} | tmux at -t ${example} | tmux attach -t ${example}: attach to session with name `example` 
- tmux kill-ses -t ${example} | tmux kill-session -t ${example}: kill/delete session example
