# Roblox Server-Side Script: Slap Without Cooldown

Slap Tanpa Jeda is a server-authoritative Roblox Luau script that lets a Tool named `Slap` activate repeatedly without a cooldown or debounce in a Roblox experience you own or are authorized to edit.

## Install

1. Open the Roblox place in Roblox Studio.
2. In Explorer, open `ServerScriptService`.
3. Insert a normal `Script` and name it `SlapNoCooldown`.
4. Copy the contents of `ServerScriptService/SlapNoCooldown.server.lua` into the new Script.
5. Make sure the Tool is named exactly `Slap`.
6. Place the Tool in `StarterPack` or give it to players at runtime.
7. Test the experience using `Start Server` with at least one player.

The script must run on the server. A `LocalScript` cannot securely control the actual hit effect in a multiplayer experience.

## Use

1. Equip the `Slap` Tool.
2. Activate the Tool while facing a living character.
3. The script performs a forward server raycast.
4. If a valid target is directly in front of the player, the target is pushed with force and upward movement.
5. The Tool can be activated repeatedly because the script contains no cooldown or debounce.

Optional Tool attributes can customize the behavior:

- `SlapRange` — number, default `8`, limited to `1`–`30` studs.
- `SlapForce` — number, default `75`, limited to `0`–`250`.
- `SlapUpwardForce` — number, default `25`, limited to `0`–`150`.
- `SlapDamage` — number, default `0`. Set it above zero to apply damage.

The script only affects a living character directly in front of the player. It does not remove or bypass cooldowns in another developer's published game.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/3ace18f7-c811-4bac-84cb-9c11d72705cb?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=3ace18f7-c811-4bac-84cb-9c11d72705cb
