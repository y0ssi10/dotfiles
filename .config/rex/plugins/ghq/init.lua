local directory = debug.getinfo(1, "S").source:gsub("^@", ""):match("^(.*)/init%.lua$")

rex.action{
  name = "ghq_open",
  title = "Open ghq Repository",
  args = { block = "string?", dir = "string?" },
  run = function(ctx, args)
    if args.dir == nil then
      assert(ctx.session_id and ctx.block_id and ctx.client_id,
        "Open the repository picker from a Rex app terminal")
      return assert(rex.session.new_layer{
        layout = rex.layout.block{
          flavor = "com.superlogical.terminal.shell",
          options = {
            shell = "none",
            command = {
              "/bin/zsh", "-lic", 'source "$1" "$2" "$3"', "rex-ghq",
              directory .. "/picker.zsh", ctx.client_id, ctx.block_id,
            },
          },
        },
        bounds = { 0.1, 0.15, 0.8, 0.7 },
        focus = true,
      })
    end

    assert(type(args.dir) == "string" and (args.dir == "" or args.dir:sub(1, 1) == "/"),
      "Expected an absolute repository directory")
    assert(type(args.block) == "string" and args.block ~= "", "Expected the invoking terminal block")
    assert(rex.session.focus_block{ block_id = args.block })
    if args.dir == "" then return end

    local label = args.dir:gsub("/+$", ""):match("([^/]+)$")
    assert(label, "Expected a repository name")
    local listed = assert(rex.call("session.list"))
    local session_id
    for _, session in ipairs(listed.sessions) do
      if session.label == label then
        assert(not session_id, "Multiple Rex sessions have label: " .. label)
        session_id = session.session_id
      end
    end

    local layout = rex.layout.block{
      flavor = "com.superlogical.terminal.shell",
      options = { cwd = args.dir },
    }
    local window_id
    if session_id then
      assert(rex.call("session.attach", { session_id = session_id }))
      local window = assert(rex.session.new_window{ session_id = session_id, layout = layout })
      window_id = window.window_id
    else
      local session = assert(rex.call("session.create", {
        label = label,
        initial_windows = { { layout = layout } },
      }))
      session_id = session.session_id
      window_id = session.initial_windows[1].window_id
    end

    rex.client.queue("session.select", { session_id = session_id, window_id = window_id })
    return { session_id = session_id, window_id = window_id }
  end,
}

rex.bind("ctrl+g", "ghq_open")
