# Tmux

## Keybinds

- Ctrl + a : `leader` key

- leader + s: list sessions
- leader + d: detach from session
- leader + ( : move to previous session
- leader + ) : move to next session
- leader + $: rename session

- leader + c : create a windows
- leader + , : rename current window
- leader + & : close current window
- leader + w : session and preview window
- leader + p : move to previous window
- leader + n : move to next window
- leader + [0...9] : move to window number

- leader + -: split pane horizontal
- leader + |: split pane vertical
- leader + (h, j, k, l): resize pane in direction left,down, up and right
- ctrl + (h, j, k, l): move between panes in direction left,down, up and right
- leader + {: move the current pane left
- leader + }: move the current pane right
- leader + q: show pane number
- leader + q + [0...9]: switch between pane by number
- leader + m: Maximize current pane
- leader + !: convert pane into a window
- leader + x: close current pane
- leader + Space: toggle between pane layouts

- leader + ':':

  - new : create a new session
  - new -s ${session-name}: create a new session with session-name
  - attach -d: detach others on the session

  - swap-window -s 2 -t 1: reorder window, swap window number 2(src) to 1(dst)
  - swap-window -t 1: move current window to the left by one position
  - movew -s 0:0 -t 1:9: move window from source to target
  - movew -s 0:9: reposition windows in the current session

  - join-pane -s 2 -t 1: join two windows as panes (Merge window 2 to window 1 as panes)
  - join-pane -s 2.1 -t 1.0: move pane Toggle synchronize-panes(send command to all panes)
  - setw synchronize-panes: from one window to another (Move pane 1 from window 2 to pane after 0 of window 1)

## Commands

- tmux | tmux new | tmux new-session: create a new session
- tmux new -s ${session-name}: create a new session with name
- tmux ls | tmux list-sessions: list all session opens in tmux
- tmux a | tmux attach | tmux at | tmux attach-session: attach to previous session
- tmux a -t | tmux attach -t ${example} | tmux at -t ${example} | tmux attach -t ${example}: attach to session with name `example`
- tmux kill-ses -t ${example} | tmux kill-session -t ${example}: kill/delete session example
