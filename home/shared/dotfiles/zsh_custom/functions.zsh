# fuzzy finder for aliases
aha() {
  local selected=$(alias | sort | fzf -q "$*")
  if [ ! -z "$selected" ]; then
    local cmd=$(awk -F'=' '{gsub(/\x27/, "", $2); print $2 }' <<< "$selected")
    eval ${=cmd}
  fi
}

# wttr.in
# https://github.com/chubin/wttr.in
wttr() {
    curl wttr.in/"${1:-}";
}

# flutter
function flutter-watch(){
  local PID_FILE="/tmp/tf$$.pid"
  TMUX='' tmux new-session \;\
    send-keys "flutter run --pid-file=$PID_FILE" Enter \;\
    split-window -v \;\
    send-keys "npx -y nodemon -e dart -x \"cat $PID_FILE | xargs kill -s USR1\"" Enter \;\
    resize-pane -y 5 -t 1 \;\
    select-pane -t 0 \;
  rm $PID_FILE;
}