-- Rex sessionizer: pick a project directory in the command palette and
-- switch to the session named after it, creating the session if needed.
-- The Rex counterpart of ../zsh-plugins/tmux-sessionizer.zsh.
local M = {}

local local_home = os.getenv("HOME")

local function expand(path, home)
  if path:sub(1, 1) == "~" then
    return home .. path:sub(2)
  end
  return path
end

local function shorten(path, home)
  if path:sub(1, #home) == home then
    return "~" .. path:sub(#home + 1)
  end
  return path
end

local function exists(path)
  local f = io.open(path, "r")
  if f == nil then
    return false
  end
  f:close()
  return true
end

local function project_dirs(opts)
  local argv = { opts.fd, "--type", "d", "--max-depth", tostring(opts.depth), "." }
  for _, dir in ipairs(opts.dirs) do
    table.insert(argv, expand(dir, local_home))
  end

  local r, err = rex.exec(argv, { timeout = 10 })
  if r == nil then
    error(err, 0)
  end

  local dirs = {}
  for line in r.stdout:gmatch("[^\n]+") do
    local dir = line:gsub("/+$", "")
    if not opts.git_only or exists(dir .. "/.git") then
      table.insert(dirs, dir)
    end
  end
  for _, dir in ipairs(opts.extra_dirs) do
    table.insert(dirs, expand(dir, local_home))
  end
  return dirs
end

-- Lists the projects of a remote host the way its tmux sessionizer does,
-- from its own TMUX_SESSIONIZER_* variables. The first line is its HOME.
local remote_script = [[
echo "$HOME"
[ "$1" = home ] && exit 0
fd --type d --max-depth "${TMUX_SESSIONIZER_DEPTH:-2}" . ${TMUX_SESSIONIZER_DIRS:-$HOME/Developer} 2>/dev/null |
  while IFS= read -r d; do
    d=${d%/}
    if [ -z "$TMUX_SESSIONIZER_GIT_ONLY" ] || [ -e "$d/.git" ]; then
      printf '%s\n' "$d"
    fi
  done
for d in $TMUX_SESSIONIZER_EXTRA_DIRS; do
  printf '%s\n' "$d"
done
]]

-- The ssh endpoint of the server a remote session lives on.
local function ssh_endpoint(server)
  local list = rex.call("hosts.list")
  for _, h in ipairs(list and list.hosts or {}) do
    if h.label == server or h.id == server then
      for _, e in ipairs(h.endpoints or { h.endpoint }) do
        if e:sub(1, 6) == "ssh://" then
          return e
        end
      end
    end
  end
  -- The host list may live only on the home server; fall back to the label.
  return server
end

local function remote_dirs(dest, home_only)
  local r, err = rex.exec(
    { "ssh", "-o", "BatchMode=yes", "-o", "ConnectTimeout=5", dest, "sh", "-s", home_only and "home" or "" },
    { stdin = remote_script, timeout = 15 }
  )
  if r == nil then
    error(err, 0)
  end
  if not r.ok then
    error("sessionizer: ssh " .. dest .. ": " .. r.stderr, 0)
  end
  local lines = {}
  for line in r.stdout:gmatch("[^\n]+") do
    table.insert(lines, line)
  end
  local home = table.remove(lines, 1)
  return lines, home
end

function M.setup(opts)
  rex.action({
    name = "sessionizer",
    title = "Sessionizer: Open Project…",
    keywords = "project session switch open directory tmux",
    args = { dir = "string?" },
    run = function(ctx, args)
      local list, err = rex.call("session.list")
      if list == nil then
        error(err, 0)
      end
      local sessions = {}
      for _, s in ipairs(list.sessions or {}) do
        sessions[s.label] = s.session_id
      end

      -- In a remote session, rex.call reaches that session's server, but
      -- rex.exec runs here, so list the remote host's projects over ssh.
      local dirs, home
      local dest = ctx.server and ssh_endpoint(ctx.server)
      if dest then
        dirs, home = remote_dirs(dest, args.dir ~= nil)
      else
        home = local_home
      end

      local dir = args.dir and expand(args.dir, home)
      if dir == nil then
        local items, seen = {}, {}
        for _, d in ipairs(dirs or project_dirs(opts)) do
          if not seen[d] and #items < 2000 then
            seen[d] = true
            local name = d:match("[^/]+$") or d
            table.insert(items, {
              id = d,
              title = name,
              subtitle = shorten(d, home),
              icon = "folder",
              detail = sessions[name] and "session" or nil,
            })
          end
        end

        local why
        dir, why = rex.ui.pick({
          title = "Open project",
          placeholder = "Filter projects",
          items = items,
        })
        if dir == nil then
          if why ~= "cancelled" then
            rex.log("warn", "sessionizer: " .. why)
          end
          return
        end
      end

      dir = dir:gsub("/+$", "")
      local name = dir:match("[^/]+$") or dir
      local id = sessions[name]
      if id == nil then
        local s, cerr = rex.call("session.create", {
          label = name,
          initial_windows = {
            {
              layout = rex.layout.block({
                flavor = "com.superlogical.terminal.shell",
                options = { cwd = dir },
              }),
            },
          },
        })
        if s == nil then
          error(cerr, 0)
        end
        id = s.session_id
      end

      rex.client.queue("session.select", { session_id = id })
    end,
  })
end

return M
