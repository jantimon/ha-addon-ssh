---
name: HomeAssistantReload
description: Reload Home Assistant YAML configuration. USE WHEN user edits YAML files OR wants to apply config changes OR asks to reload automations/scripts/scenes. Uses ha-reload for hot reload, ha core restart only when necessary.
---

# HomeAssistantReload

Intelligently reload Home Assistant configuration after YAML changes.

## When to Use Each Command

| Command           | Use When                                                                               | Downtime       |
| ----------------- | -------------------------------------------------------------------------------------- | -------------- |
| `ha-reload`       | YAML changes to automations, scripts, scenes, groups, inputs, templates, zones, themes | None (instant) |
| `ha core restart` | New integrations, logger/recorder/http changes, database settings                      | 30+ seconds    |

## Workflow

After editing YAML files:

1. **Validate first:**

   ```bash
   yamllint <file>
   ha core check
   ```

2. **Apply changes:**

   ```bash
   ha-reload
   ```

3. **Only use restart if ha-reload doesn't pick up changes** (new integrations, etc.):
   ```bash
   ha core restart
   ```

## What ha-reload Reloads

- `automation:` - automations
- `script:` - scripts
- `scene:` - scenes
- `group:` - groups
- `input_boolean:`, `input_number:`, `input_select:`, `input_text:`, `input_datetime:` - input helpers
- `template:` - template sensors/binary sensors
- `timer:`, `counter:` - timers and counters
- `schedule:` - schedules
- `zone:` - zones
- `person:` - persons
- `homeassistant:` - core config (name, location, customize)
- Themes and custom Jinja templates

## Examples

**Example 1: After editing automations.yaml**

```
User: "I updated automations.yaml, apply the changes"
→ Run: ha-reload
→ Result: Automations reloaded instantly, no restart needed
```

**Example 2: After adding a new integration**

```
User: "I added mqtt: to configuration.yaml"
→ Run: ha core restart
→ Result: Full restart required for new integrations
```

**Example 3: After editing multiple YAML files**

```
User: "Apply my config changes"
→ Run: yamllint /homeassistant/*.yaml
→ Run: ha-reload
→ Result: All hot-reloadable configs applied
```
