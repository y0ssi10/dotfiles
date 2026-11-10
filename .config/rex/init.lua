rex.action{
  name = "lazygit",
  title = "Open Lazygit",
  run = function(ctx)
    local process, process_err = rex.block.call("com.superlogical.terminal", "process", {
      block_id = ctx.block_id,
    })
    if process_err ~= nil then error(process_err, 0) end
    local cwd = process.foreground and process.foreground.cwd
    if not cwd then error("Cannot determine the current terminal directory", 0) end
    local layer, err = rex.session.new_layer{
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      focus = true,
      layout = rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        options = { cwd = cwd, command = { "lazygit" } },
      },
    }
    if err ~= nil then error(err, 0) end
    return layer
  end,
}

rex.bind("cmd+g", "lazygit")

require("plugins.ghq")
