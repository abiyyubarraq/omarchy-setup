-- Browsers driven by automation (Playwright MCP, Chrome DevTools MCP, headed
-- Playwright tests) open on workspace 5. A class rule can't do this: they use
-- the same google-chrome class as the normal browser. Automation launches the
-- browser with a debugging pipe, so the process command line tells them apart.
local automation_flags = { "--remote-debugging-pipe", "-juggler-pipe" }

local function is_automation_browser(pid)
  local file = io.open("/proc/" .. pid .. "/cmdline", "r")
  if not file then
    return false
  end
  local cmdline = file:read("*a")
  file:close()
  for _, flag in ipairs(automation_flags) do
    if cmdline:find(flag, 1, true) then
      return true
    end
  end
  return false
end

-- A tag set here comes too late for a "5 silent" workspace rule, so the window
-- is moved once it is open. The new window takes focus when it opens, so focus
-- goes back to where it was before, or the view would jump to workspace 5.
local focus_before = {}

hl.on("window.open_early", function(w)
  if w and w.pid and w.pid > 0 and is_automation_browser(w.pid) then
    local workspace = hl.get_active_workspace()
    focus_before[w.address] = {
      window = hl.get_active_window(),
      workspace = workspace and workspace.id,
    }
  end
end)

hl.on("window.open", function(w)
  local before = w and focus_before[w.address]
  if not before then
    return
  end
  focus_before[w.address] = nil
  hl.dispatch(hl.dsp.window.move({ workspace = "5", follow = false, window = w }))
  if before.workspace then
    hl.dispatch(hl.dsp.focus({ workspace = tostring(before.workspace) }))
  end
  if before.window and before.window.address ~= w.address then
    hl.dispatch(hl.dsp.focus({ window = "address:" .. before.window.address }))
  end
end)
