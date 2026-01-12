# Changelog

All notable changes to this driver will be documented in this file.

## [Unreleased]

### Added

- **Automatable LED Color Capability** (`forgeperfect33344.ledLightColor`)
  - Controls Z-Wave parameter 34
  - Values: White, Red, Orange, Yellow, Green, Cyan, Blue, Violet
  - Can be used in SmartThings Routines and automations

- **Automatable LED Intensity Capability** (`forgeperfect33344.ledLightIntensity`)
  - Controls Z-Wave parameter 35
  - Values: Off, 10%, 20%, 30%, 40%, 50%, 60%, 70%, 80%, 90%, 100%
  - Can be used in SmartThings Routines and automations

- **Automatable Guide Light Intensity Capability** (`forgeperfect33344.guideLightIntensity`)
  - Controls Z-Wave parameter 36
  - Values: Off, 10%, 20%, 30%, 40%, 50%, 60%, 70%, 80%, 90%, 100%
  - Can be used in SmartThings Routines and automations

- **Device Network ID Display** (`platemusic11009.deviceNetworkId`)
  - Shows device network ID on the main device screen
  - Useful for troubleshooting and device identification

### New Files

- `src/capabilitydefs.lua` - Custom capability definitions
- `src/config_handlers.lua` - Z-Wave configuration report handlers for LED parameters
- `capabilities/jascoLedLightColor.json` - LED color capability definition
- `capabilities/ledLightColor-presentation.json` - LED color UI presentation
- `capabilities/jascoLedLightIntensity.json` - LED intensity capability definition
- `capabilities/ledLightIntensity-presentation.json` - LED intensity UI presentation
- `capabilities/jascoGuideLightIntensity.json` - Guide light capability definition
- `capabilities/guideLightIntensity-presentation.json` - Guide light UI presentation

### Modified Files

- `src/init.lua` - Added LED capability handlers and deviceNetworkId support
- `profiles/ge-switch-scene-led.yml` - Added LED and deviceNetworkId capabilities
- `config.yml` - Updated metadata and support information

## [Upstream]

Based on upstream repository: [csstup/philh30_ST-Edge-Drivers](https://github.com/csstup/philh30_ST-Edge-Drivers)

See upstream repository for previous changelog entries.
