#!/bin/bash

# STM32WB55 I2C3 Power Consumption Test - Validation Script
# This script performs basic validation of the project structure and files

echo "=== STM32WB55 I2C3 Power Consumption Test Validation ==="
echo "Date: $(date)"
echo "Project Directory: $(pwd)"
echo

# Check project structure
echo "1. Checking project structure..."

directories=(
    "Core/Inc"
    "Core/Src"
    "Drivers/STM32WBxx_HAL_Driver/Inc"
    "Drivers/STM32WBxx_HAL_Driver/Src"
    "Drivers/CMSIS/Include"
    "Drivers/CMSIS/Device/ST/STM32WBxx/Include"
)

for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✓ $dir - OK"
    else
        echo "  ✗ $dir - MISSING"
    fi
done

echo

# Check essential files
echo "2. Checking essential files..."

files=(
    "Core/Inc/main.h"
    "Core/Inc/stm32wbxx_hal_conf.h"
    "Core/Inc/stm32wbxx_it.h"
    "Core/Src/main.c"
    "Core/Src/stm32wbxx_hal_msp.c"
    "Core/Src/stm32wbxx_it.c"
    "Core/Src/system_stm32wbxx.c"
    "Makefile"
    "README.md"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file - OK"
    else
        echo "  ✗ $file - MISSING"
    fi
done

echo

# Check for key functions in main.c
echo "3. Checking key functions in main.c..."

functions=(
    "SystemClock_Config_HSE_LSE"
    "SystemClock_Config_HSI_LSE"
    "MX_I2C3_Init"
    "Switch_Clock_Source"
    "I2C3_Power_Test"
    "Run_Power_Consumption_Tests"
    "Power_Measurement_Start"
    "Power_Measurement_Stop"
)

if [ -f "Core/Src/main.c" ]; then
    for func in "${functions[@]}"; do
        if grep -q "$func" "Core/Src/main.c"; then
            echo "  ✓ $func - Found"
        else
            echo "  ✗ $func - NOT FOUND"
        fi
    done
else
    echo "  ✗ main.c not found, skipping function check"
fi

echo

# Check for key defines in main.h
echo "4. Checking key definitions in main.h..."

defines=(
    "POWER_TEST_DURATION_MS"
    "I2C_TEST_DATA_SIZE"
    "I2C_TEST_ADDRESS"
    "I2C3_SCL_PIN"
    "I2C3_SDA_PIN"
)

if [ -f "Core/Inc/main.h" ]; then
    for define in "${defines[@]}"; do
        if grep -q "#define $define" "Core/Inc/main.h"; then
            echo "  ✓ $define - Found"
        else
            echo "  ✗ $define - NOT FOUND"
        fi
    done
else
    echo "  ✗ main.h not found, skipping defines check"
fi

echo

# Check file sizes (basic sanity check)
echo "5. Checking file sizes..."

size_check_files=(
    "Core/Src/main.c"
    "Core/Inc/main.h"
    "README.md"
)

for file in "${size_check_files[@]}"; do
    if [ -f "$file" ]; then
        size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
        if [ "$size" -gt 1000 ]; then
            echo "  ✓ $file - $size bytes"
        else
            echo "  ⚠ $file - $size bytes (may be incomplete)"
        fi
    else
        echo "  ✗ $file - NOT FOUND"
    fi
done

echo

# Summary
echo "=== Validation Summary ==="
echo "Project validation completed."
echo "If all items show ✓, the project structure is ready for compilation."
echo
echo "Next steps:"
echo "1. Install ARM GCC toolchain"
echo "2. Run 'make clean && make all' to build the project"
echo "3. Flash the generated .hex file to STM32WB55 target"
echo "4. Connect power measurement equipment"
echo "5. Monitor I2C3 power consumption under different clock sources"
echo

exit 0