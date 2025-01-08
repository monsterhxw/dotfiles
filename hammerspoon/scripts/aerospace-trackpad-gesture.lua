-- Ref: https://github.com/nikitabobko/AeroSpace/issues/448#issuecomment-2317761083

-- https://github.com/mogenson/Swipe.spoon
Swipe = hs.loadSpoon("Swipe")

local config = {
  fingers = 4,
  -- 0.1 = swipe distance > 10% of trackpad
  threshold = 0.08,
  showAlert = true,
  alertDuration = 0.4
}

local AEROSPACE = "/usr/local/bin/aerospace"
function aerospaceExec(cmd)
  local command = string.format('%s list-workspaces --monitor mouse --visible | xargs %s workspace && %s workspace %s', AEROSPACE, AEROSPACE, AEROSPACE, cmd)

  hs.execute(command)
  
  if config.showAlert then
    hs.alert.show("AeroSpace " .. cmd, config.alertDuration)
  end
end

-- use four finger swipe to switch workspace
local current_id, threshold

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
