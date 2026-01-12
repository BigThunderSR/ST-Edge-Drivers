# Development Guide: Adding Automatable Capabilities to SmartThings Edge Drivers

This guide documents the process of adding custom automatable capabilities to a SmartThings Edge Driver, using the LED control capabilities as an example.

## Overview

SmartThings Edge Drivers can expose device settings as either:

1. **Preferences** - Configurable in device settings, but NOT automatable
2. **Capabilities** - Appear on device main page and CAN be used in Routines/automations

This guide covers converting preference-based settings to capability-based settings.

## Prerequisites

- SmartThings CLI installed (`smartthings` command)
- SmartThings developer account with a namespace
- Access to a SmartThings Hub
- A channel for driver distribution

## Step 1: Create Custom Capability Definitions

### 1.1 Create Capability JSON

Create a JSON file in `capabilities/` folder defining the capability:

```json
{
  "id": "yournamespace.capabilityName",
  "version": 1,
  "name": "Capability Display Name",
  "status": "proposed",
  "attributes": {
    "attributeName": {
      "schema": {
        "type": "object",
        "properties": {
          "value": {
            "type": "string",
            "enum": ["Value1", "Value2", "Value3"]
          }
        },
        "additionalProperties": false,
        "required": ["value"]
      }
    }
  },
  "commands": {
    "setAttributeName": {
      "name": "setAttributeName",
      "arguments": [
        {
          "name": "value",
          "schema": {
            "type": "string",
            "enum": ["Value1", "Value2", "Value3"]
          },
          "required": true
        }
      ]
    }
  }
}
```

### 1.2 Create Capability Presentation JSON

Create a presentation file (`capabilityName-presentation.json`) for UI rendering:

```json
{
  "dashboard": {
    "states": [
      {
        "label": "{{attributeName.value}}"
      }
    ],
    "actions": []
  },
  "detailView": [
    {
      "label": "Capability Label",
      "displayType": "list",
      "list": {
        "state": {
          "value": "attributeName.value",
          "valueType": "string"
        },
        "command": {
          "name": "setAttributeName",
          "argumentType": "string"
        },
        "alternatives": [
          { "key": "Value1", "value": "Value1" },
          { "key": "Value2", "value": "Value2" },
          { "key": "Value3", "value": "Value3" }
        ]
      }
    }
  ],
  "automation": {
    "conditions": [
      {
        "label": "Capability Label",
        "displayType": "list",
        "list": {
          "value": "attributeName.value",
          "valueType": "string",
          "alternatives": [
            { "key": "Value1", "value": "Value1" },
            { "key": "Value2", "value": "Value2" },
            { "key": "Value3", "value": "Value3" }
          ]
        }
      }
    ],
    "actions": [
      {
        "label": "Capability Label",
        "displayType": "list",
        "list": {
          "command": "setAttributeName",
          "argumentType": "string",
          "alternatives": [
            { "key": "Value1", "value": "Value1" },
            { "key": "Value2", "value": "Value2" },
            { "key": "Value3", "value": "Value3" }
          ]
        }
      }
    ]
  }
}
```

**CRITICAL**: The presentation format is very specific. Key learnings:

- Do NOT include `supportedValues` in command sections
- Use `valueType: "string"` for state values
- Use `argumentType: "string"` for commands
- Keep dashboard states simple (no alternatives)
- Match `alternatives` keys and values exactly to capability enum

### 1.3 Register Capabilities with SmartThings

```bash
# Create capability
smartthings capabilities:create -i capabilities/capabilityName.json

# Create presentation
smartthings capabilities:presentation:create yournamespace.capabilityName 1 -i capabilities/capabilityName-presentation.json
```

## Step 2: Create Lua Capability Definitions

Create `src/capabilitydefs.lua`:

```lua
local capabilities = require('st.capabilities')

local capabilitydefs = {}

capabilitydefs.MyCapability = {}
capabilitydefs.MyCapability.name = "yournamespace.capabilityName"
capabilitydefs.MyCapability.capability = capabilities[capabilitydefs.MyCapability.name]

return capabilitydefs
```

## Step 3: Create Command/Report Handlers

Create `src/config_handlers.lua` for Z-Wave configuration parameter handling:

```lua
local capdefs = require('capabilitydefs')
local MyCapability = capdefs.MyCapability.capability

-- Map parameter values to capability values
local VALUE_MAP = {
  [1] = "Value1",
  [2] = "Value2",
  [3] = "Value3",
}

-- Reverse map for commands
local REVERSE_MAP = {}
for k, v in pairs(VALUE_MAP) do
  REVERSE_MAP[v] = k
end

-- Handler for configuration reports from device
local function configuration_report_handler(driver, device, cmd)
  local param = cmd.args.parameter_number
  local value = cmd.args.configuration_value

  if param == YOUR_PARAMETER_NUMBER then
    local mapped_value = VALUE_MAP[value] or "Unknown"
    device:emit_event(MyCapability.attributeName({ value = mapped_value }))
  end
end

return {
  configuration_report_handler = configuration_report_handler,
  REVERSE_MAP = REVERSE_MAP,
}
```

## Step 4: Update init.lua

Add handlers for capability commands:

```lua
local capdefs = require('capabilitydefs')
local config_handlers = require('config_handlers')

local MyCapability = capdefs.MyCapability.capability

-- Command handler
local function handle_set_my_capability(driver, device, command)
  local value = command.args.value
  local param_value = config_handlers.REVERSE_MAP[value]

  if param_value then
    device:send(Configuration:Set({
      parameter_number = YOUR_PARAMETER_NUMBER,
      size = 1,
      configuration_value = param_value
    }))
    -- Emit event immediately for responsive UI
    device:emit_event(MyCapability.attributeName({ value = value }))
  end
end

-- Register in driver template
local driver_template = {
  supported_capabilities = {
    -- ... existing capabilities ...
    MyCapability,
  },
  capability_handlers = {
    -- ... existing handlers ...
    [MyCapability.ID] = {
      [MyCapability.commands.setAttributeName.NAME] = handle_set_my_capability,
    },
  },
  zwave_handlers = {
    [cc.CONFIGURATION] = {
      [Configuration.REPORT] = config_handlers.configuration_report_handler,
    },
  },
}
```

## Step 5: Update Device Profile

Add capability to profile YAML (`profiles/your-profile.yml`):

```yaml
name: your-profile
components:
  - id: main
    capabilities:
      - id: switch
        version: 1
      - id: yournamespace.capabilityName
        version: 1
      - id: refresh
        version: 1
```

## Step 6: Package and Deploy

```bash
# Package driver
smartthings edge:drivers:package /path/to/driver

# Upload to channel
smartthings edge:channels:assign CHANNEL_ID

# Install on hub
smartthings edge:drivers:install --hub HUB_ID --channel CHANNEL_ID DRIVER_ID
```

## Step 7: Force Hub Update (if needed)

If the hub doesn't pull the new version:

```bash
# Uninstall driver
smartthings edge:drivers:uninstall --hub HUB_ID DRIVER_ID

# Reinstall from channel
smartthings edge:drivers:install --hub HUB_ID --channel CHANNEL_ID DRIVER_ID

# Switch device to driver
smartthings edge:drivers:switch DEVICE_ID --hub HUB_ID --driver DRIVER_ID
```

## Troubleshooting

### App Crashes When Creating Routines

- Check presentation JSON format
- Remove `supportedValues` from command sections
- Ensure `valueType` and `argumentType` are present

### Dropdown Shows Values Vertically (One Letter Per Line)

- This indicates a malformed presentation
- Check that `alternatives` array is properly formatted
- Ensure keys match capability enum values exactly

### Capability Not Appearing on Device

- Verify capability is in profile YAML
- Check that capability is registered with SmartThings
- May need to reconfigure device or change profiles

### Hub Not Pulling New Driver Version

- Use uninstall/reinstall method
- Check `smartthings edge:drivers:installed --hub HUB_ID` for version

## Useful Commands

```bash
# List installed drivers on hub
smartthings edge:drivers:installed --hub HUB_ID

# View driver details
smartthings edge:drivers DRIVER_ID

# Check channel drivers
smartthings edge:channels:drivers CHANNEL_ID

# View device info
smartthings devices DEVICE_ID

# Get capability definition
smartthings capabilities yournamespace.capabilityName

# Get capability presentation
smartthings capabilities:presentation yournamespace.capabilityName 1
```

## File Structure

```text
your-driver/
├── config.yml                 # Driver metadata
├── fingerprints.yml           # Device fingerprints
├── README.md                  # Documentation
├── CHANGELOG.md               # Version history
├── capabilities/
│   ├── capability1.json       # Capability definition
│   ├── capability1-presentation.json
│   └── ...
├── profiles/
│   ├── default.yml
│   └── custom-profile.yml     # Profile with custom capabilities
└── src/
    ├── init.lua               # Main driver entry
    ├── capabilitydefs.lua     # Capability references
    └── config_handlers.lua    # Parameter handlers
```

## References

- [SmartThings Edge Driver Documentation](https://developer.smartthings.com/docs/edge-device-drivers)
- [SmartThings Capabilities Reference](https://developer.smartthings.com/docs/devices/capabilities/capabilities-reference)
- [SmartThings CLI Documentation](https://github.com/SmartThingsCommunity/smartthings-cli)

## Author

BigThunderSR - January 2026
