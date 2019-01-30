# DiscordHook for ComputerCraft (CC:Tweaked)
This is DiscordHook, an easy-to-use lua library for connecting ComputerCraft to Discord.

You can use this library to easily send messages, images, stories, logs and embeds to a Discord channel of your choice. The messages will be send from a 'bot' user, as this library uses Discord's Webhook feature. Use this to easily log activity around your base, create a chat bridge, allow remote logging or anything else you can think of!

#### Main features
- Easy to use
- Checks if the webhook is reachable
- Sends normal messages
- Sends raw JSON messages
- Sends embeds / rich messages (easy to create!)
- Allows you to customize the bots name and avatar (per message)

----

## Documentation and instructions

Below I will describe the following:
1. *Installation*
2. *Creating a Discord Webhook*
3. *Using a Discord Webhook with DiscordHook*

### 1. Installing DiscordHook

To get the library, simply download the lua file by executing the following in your shell:
```
wget https://github.com/Wendelstein7/DiscordHook-CC/blob/master/DiscordHook.lua DiscordHook.lua
```
If you want to use this library as a dependency in a program that you'll distribute, simply make it download `https://github.com/Wendelstein7/DiscordHook-CC/blob/master/DiscordHook.lua` directly if the library isn't found.

### 2. Creating a Discord Webhook

First, make sure you're a moderator or administrator in a Discord server or create a new Discord server.
Then, go to the **server settings** and tap '**Webhooks**' on your left bar.
Now, click '**Create Webhook**' on the top-right. A Webhook is now created for you. It's bound to a specific channel.
Copy *(use the button)* and paste down the **webhook url**, as you'll need this later in your CC program!

### 3. Using a Discord Webhook with DiscordHook

First, we must `require` the program in lua, to be able to access its functions, put this in the beginning of your pogram: *(It assumes the DiscordHook.lua file is in the root of your filesystem)*
```lua
local DiscordHook = require("DiscordHook")
```

At some point we want to start sending stuff to Discord. Before we can do this, we must first make a *webhook object*. the `createWebhook(<string url>)` function will check if the webhook url is valid and reachable. The first return value is `boolean success` and the second value is either the `webhook object` if the creation succeeded or `string error-message` if the creation failed. *(For example, when the url was invalid, http is blocked or Discord is ratelimiting your IP)*
```lua
local success, hook = DiscordHook.createWebhook("https://discordapp.com/api/webhooks/... (THE URL YOU GOT FROM DISCORD)")
if not success then
  error("Webhook connection failed! Reason: " .. hook)
end

-- If the code execution continues here, that means we have the webhook available as it didn't error.
```

Now, let's send some messages! There are various methods available with one or more arguments.
Meanings: **<required argument> [optional argument]**
```lua
-- Sending normal plain good ol' messages:
hook.send(<string message>, [string username], [string avatarurl])

-- If you want to compose the message json yourself:
hook.sendJSON(<string json>)

-- If you want to create a fancy embed:
hook.sendEmbed(<string message>, [string title], [string description], [string hyperlink-url], [number colour], [string image-url], [string thumbnail-url], [string username], [string avatar])
```
All functions return a *boolean* - `true` if the webhook executed without problems or `false` if the webhook failed (for example, when Discord rejected an invalid embed.)

**Note:** By Discord's rules, an embed must *atleast* either have a title or description, but not neccecarily both.
Fill arguments you don't want with `nil`, for example: `hook.sendEmbed("", nil, "Hello!", nil, 0xFF00FF)` and `hook.sendEmbed("Hello sir!", nil, "https://example.com/avatar.jpg")` will work just fine!.
A string for `message` is always required, but is allowed to be empty (`""`) when having a valid embed.
