# GE Z-Wave Switch/Dimmer/Fan/Outlet

SmartThings Edge Driver for GE/Jasco/Honeywell/Ultrapro Z-Wave switches, dimmers, fans, and outlets.

## Fork Information

**Developer:** BigThunderSR  
**Upstream:** [csstup/philh30_ST-Edge-Drivers](https://github.com/csstup/philh30_ST-Edge-Drivers)  
**Original Authors:** philh30, csstup

## What's Different in This Fork

This fork adds **automatable LED control capabilities** for compatible GE/Jasco switches. Instead of only being able to change LED settings through device preferences (which cannot be automated), this fork exposes them as capabilities that can be used in SmartThings Routines and automations.

### Added Capabilities

| Capability                              | Description              | Z-Wave Parameter |
| --------------------------------------- | ------------------------ | ---------------- |
| `forgeperfect33344.ledLightColor`       | LED indicator color      | Parameter 34     |
| `forgeperfect33344.ledLightIntensity`   | LED indicator brightness | Parameter 35     |
| `forgeperfect33344.guideLightIntensity` | Guide light brightness   | Parameter 36     |

### Supported Values

**LED Color (Parameter 34):**

- White, Red, Orange, Yellow, Green, Cyan, Blue, Violet

**LED Intensity (Parameter 35):**

- Off, 10%, 20%, 30%, 40%, 50%, 60%, 70%, 80%, 90%, 100%

**Guide Light Intensity (Parameter 36):**

- Off, 10%, 20%, 30%, 40%, 50%, 60%, 70%, 80%, 90%, 100%

## Supported Models

This driver supports the same models as the upstream driver, but the LED capabilities are specifically designed for models with configurable LED indicators, such as:

- GE Smart Toggle Switch 58436 (fingerprint 0063-4952-3330)
- Other GE/Jasco switches with LED parameters 34, 35, 36

## Installation

1. Subscribe to the driver channel
2. Install the driver to your hub
3. Switch your device to use this driver
4. LED capabilities will appear on the device's main page and in Routines

## Usage in Automations

Once installed, you can create SmartThings Routines that:

- Change LED color based on time of day
- Adjust LED brightness based on conditions
- Set guide light intensity for nighttime navigation
- Coordinate LED colors across multiple switches

## Credits

- **philh30** - Original driver author
- **csstup** - Upstream repository maintainer
- **BigThunderSR** - LED capability additions

## License

Apache License 2.0 - See [LICENSE](../../LICENSE)

## Links

- [SmartThings Community Discussion](https://community.smartthings.com/t/st-edge-driver-for-ge-jasco-honeywell-z-wave-switches-dimmers-fans-outlets-and-plug-ins/236733)
- [Upstream Repository](https://github.com/csstup/philh30_ST-Edge-Drivers)
