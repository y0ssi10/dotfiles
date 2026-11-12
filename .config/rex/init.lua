local function terminal_cwd(ctx)
  local process, err = rex.block.call("com.superlogical.terminal", "process", {
    block_id = ctx.block_id,
  })
  if err ~= nil then error(err, 0) end
  local cwd = process.foreground and process.foreground.cwd
  if not cwd then error("Cannot determine the current terminal directory", 0) end
  return cwd
end

rex.action{
  name = "lazygit",
  title = "Open Lazygit",
  run = function(ctx)
    local cwd = terminal_cwd(ctx)
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

rex.action{
  name = "zed",
  title = "Open Current Directory in Zed",
  run = function(ctx)
    local cwd = terminal_cwd(ctx)
    local result, err = rex.exec({ "/usr/bin/open", "-a", "Zed", cwd })
    if err ~= nil then error(err, 0) end
    if not result.ok then
      error("Failed to open Zed (exit " .. result.code .. "): " .. result.stderr, 0)
    end
    return result
  end,
}

rex.bind("cmd+e", "zed")

require("plugins.ghq")
