-- Ref: https://github.com/nikitabobko/AeroSpace/issues/448#issuecomment-2317761083

-- https://github.com/mogenson/Swipe.spoon
Swipe = hs.loadSpoon("Swipe")

local config = {
  fingers = 4,
  -- 0.1 = swipe distance > 10% of trackpad
  threshold = 0.08,
  showAlert = false,
  alertDuration = 0.3,
  -- wrap around from the last workspace back to the first (and vice versa).
  -- kept off so it's obvious when you hit the first/last workspace.
  wrapAround = false
}

local AEROSPACE = "/usr/local/bin/aerospace"
function aerospaceExec(cmd)
  -- Uses `aerospace eval` (added in AeroSpace 0.21.0-Beta) to run the whole
  -- chain in a single aerospace process instead of the old
  -- `list-workspaces | xargs aerospace workspace && aerospace workspace ...`,
  -- which spawned multiple processes per swipe. See release notes:
  -- https://github.com/nikitabobko/AeroSpace/releases/tag/v0.21.0-Beta
  --
  -- First segment focuses the workspace visible on the monitor under the mouse
  -- (single-element stdin list, so `next` here is just a placeholder). The
  -- second segment does the actual next/prev switch.
  local wrap = config.wrapAround and " --wrap-around" or ""
  local command = string.format(
    "%s eval 'list-workspaces --monitor mouse --visible | workspace --stdin next; workspace %s%s'",
    AEROSPACE, cmd, wrap
  )

  hs.execute(command)
  
  if config.showAlert then
    hs.alert.show("AeroSpace: " .. cmd, config.alertDuration)
  end
end

local current_id, threshold
-- use 4-fingers swipe to switch workspace
Swipe:start(config.fingers, function(direction, distance, id)
  if id == current_id then
    if distance > threshold then
      -- only trigger once per swipe
      threshold = math.huge
      if direction == "left" then
        aerospaceExec("next")
      elseif direction == "right" then 
        aerospaceExec("prev")
      end
    end
  else
    current_id = id
    threshold = config.threshold
  end
end)
