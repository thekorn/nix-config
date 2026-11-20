-- Rex sessionizer: pick a project directory in the command palette and
-- switch to the session named after it, creating the session if needed.
-- The Rex counterpart of ../zsh-plugins/tmux-sessionizer.zsh.
local M = {}

local home = os.getenv("HOME")

local function expand(path)
  if path:sub(1, 1) == "~" then
    return home .. path:sub(2)
  end
  return path
end

local function shorten(path)
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
    table.insert(argv, expand(dir))
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
    table.insert(dirs, expand(dir))
  end
  return dirs
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

      local dir = args.dir and expand(args.dir)
      if dir == nil then
        local items, seen = {}, {}
        for _, d in ipairs(project_dirs(opts)) do
          if not seen[d] and #items < 2000 then
            seen[d] = true
            local name = d:match("[^/]+$") or d
            table.insert(items, {
              id = d,
              title = name,
              subtitle = shorten(d),
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
