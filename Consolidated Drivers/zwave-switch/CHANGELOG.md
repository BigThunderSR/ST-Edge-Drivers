# Changelog

All notable changes to this driver will be documented in this file.

## [2026-01-12]

### Added

- **Automatable LED Indicator Status Capability** (`forgeperfect33344.ledIndicatorStatus`)
  - Controls Z-Wave parameter 3
  - Values: whenOff (LED on when switch off), whenOn (LED on when switch on), alwaysOff, alwaysOn
  - Available on all GE/Jasco/Honeywell/UltraPro devices
  - Can be used in SmartThings Routines and automations

- **Automatable LED Color Capability** (`forgeperfect33344.ledLightColor`)
  - Controls Z-Wave parameter 34
  - Values: Red, Orange, Yellow, Green, Blue, Pink, Purple, White
  - Can be used in SmartThings Routines and automations

- **Automatable LED Intensity Capability** (`forgeperfect33344.ledLightIntensity`)
  - Controls Z-Wave parameter 35
  - Values: 1 (lowest) through 7 (highest)
  - Can be used in SmartThings Routines and automations

- **Automatable Guide Light Intensity Capability** (`forgeperfect33344.guideLightIntensity`)
  - Controls Z-Wave parameter 36
  - Values: 1 (lowest) through 7 (highest)
  - Can be used in SmartThings Routines and automations

- **Device Network ID Display** (`platemusic11009.deviceNetworkId`)
  - Shows device network ID on the main device screen
  - Useful for troubleshooting and device identification

### New Files

- `capabilities/forgeperfect33344/ledIndicatorStatus.json` - LED indicator status capability definition
- `capabilities/forgeperfect33344/ledIndicatorStatus-presentation.json` - LED indicator status UI presentation
- `capabilities/forgeperfect33344/ledLightColor.json` - LED color capability definition
- `capabilities/forgeperfect33344/ledLightColor-presentation.json` - LED color UI presentation
- `capabilities/forgeperfect33344/ledLightIntensity.json` - LED intensity capability definition
- `capabilities/forgeperfect33344/ledLightIntensity-presentation.json` - LED intensity UI presentation
- `capabilities/forgeperfect33344/guideLightIntensity.json` - Guide light capability definition
- `capabilities/forgeperfect33344/guideLightIntensity-presentation.json` - Guide light UI presentation

### Modified Files

- `src/init.lua` - Added LED capability definitions
- `src/ge-switch/init.lua` - Added LED capability handlers and configuration report handler
- `profiles/ge-switch-scene-led.yml` - Added LED color/intensity capabilities to profile
- `profiles/ge-*-scene*.yml` - Added LED Indicator Status capability to 7 scene profiles (legacy/assoc profiles excluded - only support 3 options)
- `config.yml` - Updated driver name and metadata

## [Upstream]

Based on upstream repository: [csstup/philh30_ST-Edge-Drivers](https://github.com/csstup/philh30_ST-Edge-Drivers)

See upstream repository for previous changelog entries.
