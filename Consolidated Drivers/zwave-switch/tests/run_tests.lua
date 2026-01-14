-- Unit tests for GE Switch LED mappings
-- Run with: lua5.3 tests/run_tests.lua

local tests_passed = 0
local tests_failed = 0

local function test(name, condition)
    if condition then
        print("✓ " .. name)
        tests_passed = tests_passed + 1
    else
        print("✗ " .. name)
        tests_failed = tests_failed + 1
    end
end

-- LED Color mappings (Parameter 34)
-- SmartThings UI value -> Z-Wave parameter value
local LED_COLOR_MAP = {
    ["red"] = 1,
    ["orange"] = 2,
    ["yellow"] = 3,
    ["green"] = 4,
    ["blue"] = 5,
    ["pink"] = 6,
    ["purple"] = 7,
    ["white"] = 8
}

-- Reverse mapping for configuration reports
local LED_COLOR_REVERSE = {}
for k, v in pairs(LED_COLOR_MAP) do
    LED_COLOR_REVERSE[v] = k
end

-- LED Intensity mappings (Parameters 35, 36)
-- Values 1-7 map directly
local LED_INTENSITY_MAP = {
    ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4,
    ["5"] = 5, ["6"] = 6, ["7"] = 7
}

local LED_INTENSITY_REVERSE = {}
for k, v in pairs(LED_INTENSITY_MAP) do
    LED_INTENSITY_REVERSE[v] = k
end

-- LED Indicator Status mappings (Parameter 3)
local LED_INDICATOR_MAP = {
    ["whenOff"] = 0,
    ["whenOn"] = 1,
    ["alwaysOff"] = 2,
    ["alwaysOn"] = 3
}

local LED_INDICATOR_REVERSE = {}
for k, v in pairs(LED_INDICATOR_MAP) do
    LED_INDICATOR_REVERSE[v] = k
end

print("\n=== LED Color Mapping Tests ===")
test("Red maps to 1", LED_COLOR_MAP["red"] == 1)
test("Orange maps to 2", LED_COLOR_MAP["orange"] == 2)
test("Yellow maps to 3", LED_COLOR_MAP["yellow"] == 3)
test("Green maps to 4", LED_COLOR_MAP["green"] == 4)
test("Blue maps to 5", LED_COLOR_MAP["blue"] == 5)
test("Pink maps to 6", LED_COLOR_MAP["pink"] == 6)
test("Purple maps to 7", LED_COLOR_MAP["purple"] == 7)
test("White maps to 8", LED_COLOR_MAP["white"] == 8)

print("\n=== LED Color Reverse Mapping Tests ===")
test("1 maps to red", LED_COLOR_REVERSE[1] == "red")
test("2 maps to orange", LED_COLOR_REVERSE[2] == "orange")
test("3 maps to yellow", LED_COLOR_REVERSE[3] == "yellow")
test("4 maps to green", LED_COLOR_REVERSE[4] == "green")
test("5 maps to blue", LED_COLOR_REVERSE[5] == "blue")
test("6 maps to pink", LED_COLOR_REVERSE[6] == "pink")
test("7 maps to purple", LED_COLOR_REVERSE[7] == "purple")
test("8 maps to white", LED_COLOR_REVERSE[8] == "white")

print("\n=== LED Intensity Mapping Tests ===")
for i = 1, 7 do
    test("Intensity " .. i .. " maps correctly", LED_INTENSITY_MAP[tostring(i)] == i)
end

print("\n=== LED Intensity Reverse Mapping Tests ===")
for i = 1, 7 do
    test("Intensity " .. i .. " reverse maps correctly", LED_INTENSITY_REVERSE[i] == tostring(i))
end

print("\n=== LED Indicator Status Mapping Tests ===")
test("whenOff maps to 0", LED_INDICATOR_MAP["whenOff"] == 0)
test("whenOn maps to 1", LED_INDICATOR_MAP["whenOn"] == 1)
test("alwaysOff maps to 2", LED_INDICATOR_MAP["alwaysOff"] == 2)
test("alwaysOn maps to 3", LED_INDICATOR_MAP["alwaysOn"] == 3)

print("\n=== LED Indicator Reverse Mapping Tests ===")
test("0 maps to whenOff", LED_INDICATOR_REVERSE[0] == "whenOff")
test("1 maps to whenOn", LED_INDICATOR_REVERSE[1] == "whenOn")
test("2 maps to alwaysOff", LED_INDICATOR_REVERSE[2] == "alwaysOff")
test("3 maps to alwaysOn", LED_INDICATOR_REVERSE[3] == "alwaysOn")

-- LED Indicator Basic mappings (Parameter 3 - 3-option version for outlets/plugins/fans)
-- Only supports values 0, 1, 2 (no "alwaysOn")
local LED_INDICATOR_BASIC_MAP = {
    ["whenOff"] = 0,
    ["whenOn"] = 1,
    ["alwaysOff"] = 2
}

local LED_INDICATOR_BASIC_REVERSE = {}
for k, v in pairs(LED_INDICATOR_BASIC_MAP) do
    LED_INDICATOR_BASIC_REVERSE[v] = k
end

print("\n=== LED Indicator Basic Mapping Tests (3-option) ===")
test("Basic whenOff maps to 0", LED_INDICATOR_BASIC_MAP["whenOff"] == 0)
test("Basic whenOn maps to 1", LED_INDICATOR_BASIC_MAP["whenOn"] == 1)
test("Basic alwaysOff maps to 2", LED_INDICATOR_BASIC_MAP["alwaysOff"] == 2)
test("Basic does NOT have alwaysOn", LED_INDICATOR_BASIC_MAP["alwaysOn"] == nil)

print("\n=== LED Indicator Basic Reverse Mapping Tests ===")
test("Basic 0 maps to whenOff", LED_INDICATOR_BASIC_REVERSE[0] == "whenOff")
test("Basic 1 maps to whenOn", LED_INDICATOR_BASIC_REVERSE[1] == "whenOn")
test("Basic 2 maps to alwaysOff", LED_INDICATOR_BASIC_REVERSE[2] == "alwaysOff")
test("Basic has no mapping for 3", LED_INDICATOR_BASIC_REVERSE[3] == nil)

print("\n=== Summary ===")
print(string.format("Passed: %d, Failed: %d", tests_passed, tests_failed))

if tests_failed > 0 then
    os.exit(1)
end
