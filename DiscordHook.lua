--[[
  DiscordHook by HydroNitrogen
  Licenced under MIT
  Copyright (c) 2019 Wendelstein7 (a.k.a. HydroNitrogen)
  See: https://github.com/Wendelstein7/DiscordHook-CC
]]--

local DiscordHook = {
  ["name"] = "DiscordHook",
  ["author"] = "HydroNitrogen",
  ["date"] = "2019-01-30",
  ["version"] = 1,
  ["url"] = "https://github.com/Wendelstein7/DiscordHook-CC"
}

local function expect(func, arg, n, expected)
  if type(arg) ~= expected then
    return error(("%s: bad argument #%d (expected %s, got %s)"):format(func, n, expected, type(arg)), 2)
  end
end

local function send(url, data, headers)
  local request, message = http.post(url, data, headers)
  if not request then
    return false
  end
  return true
end

function DiscordHook.createWebhook(url)
  expect("createWebhook", url, 1, "string")
  local success, message = http.checkURL(url)
  if not success then
    return false, "createWebhook: Can't access invalid url - " .. message
  else
    local _ = {}
    _.url = url
    _.sentMessages = 0

    function _.send(message, username, avatar)
      expect("send", message, 1, "string")
      local data = "content=" .. textutils.urlEncode(message)
      if username then
        expect("send", username, 2, "string")
        data = data .. "&username=" .. textutils.urlEncode(username)
      end
      if avatar then
        expect("send", avatar, 3, "string")
        data = data .. "&avatar_url=" .. textutils.urlEncode(avatar)
      end

      
      local success = send(_.url, data, { ["Content-Type"] = "application/x-www-form-urlencoded", ["Source"] = "Minecraft/ComputerCraft/DiscordHook" })
      if success then _.sentMessages = _.sentMessages + 1 end
      return success
    end

    function _.sendJSON(json)
      expect("sendJSON", json, 1, "string")

      local success = send(_.url, json, { ["Content-Type"] = "application/json", ["Source"] = "Minecraft/ComputerCraft/DiscordHook" })
      if success then _.sentMessages = _.sentMessages + 1 end
      return success
    end

    function _.sendEmbed(message, title, description, link, colour, image_large, image_thumb, username, avatar)
      expect("sendEmbed", message, 1, "string")
      local data = { ["content"] = message, ["embeds"] = { {} } }

      if title then
        expect("sendEmbed", title, 2, "string")
        data["embeds"][1]["title"] = title
      end
      if description then
        expect("sendEmbed", description, 3, "string")
        data["embeds"][1]["description"] = description
      end
      if link then
        expect("sendEmbed", link, 4, "string")
        data["embeds"][1]["url"] = link
      end
      if colour then
        expect("sendEmbed", colour, 5, "number")
        data["embeds"][1]["color"] = colour
      end
      if image_large then
        expect("sendEmbed", image_large, 6, "string")
        data["embeds"][1]["image"] = { ["url"] = image_large }
      end
      if image_thumb then
        expect("sendEmbed", image_thumb, 7, "string")
        data["embeds"][1]["thumbnail"] = { ["url"] = image_thumb }
      end
      if username then
        expect("sendEmbed", username, 8, "string")
        data["username"] = username
      end
      if avatar then
        expect("sendEmbed", avatar, 9, "string")
        data["avatar_url"] = avatar
      end
      
      local success = send(_.url, textutils.serializeJSON(data), { ["Content-Type"] = "application/json", ["Source"] = "Minecraft/ComputerCraft/DiscordHook" })
      if success then _.sentMessages = _.sentMessages + 1 end
      return success
    end

    return true, _
  end
end

return DiscordHook
