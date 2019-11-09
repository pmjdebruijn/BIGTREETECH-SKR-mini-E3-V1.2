#!/bin/sh
#
# SKR mini E3   Marlin 2.0   firmware build script
#
# Copyright (c) 2019 Pascal de Bruijn
#



VENV_DIR=PlatformIO
MARLIN_DIR=Marlin



python3 -m venv ${VENV_DIR}

./${VENV_DIR}/bin/pip install -U platformio --no-cache-dir



git clone https://github.com/MarlinFirmware/Marlin ${MARLIN_DIR}

git -C ${MARLIN_DIR} checkout bugfix-2.0.x
git -C ${MARLIN_DIR} describe --tags



sed -i 's@\[platformio\]@\[platformio\]\ncore_dir = PlatformIO@' ${MARLIN_DIR}/platformio.ini

sed -i 's@default_envs.*=.*@default_envs = STM32F103RC_bigtree@' ${MARLIN_DIR}/platformio.ini

sed -i 's@TMCStepper.*@#&\n  https://github.com/bigtreetech/TMCStepper@' ${MARLIN_DIR}/platformio.ini

# no longer needed?
#sed -i 's@Adafruit NeoPixel.*@#&\n  https://github.com/bigtreetech/Adafruit_NeoPixel@' ${MARLIN_DIR}/platformio.ini

# this will be rather fragile, but it works for the time being
sed -i 's@  ${common.build_flags} -DDEBUG_LEVEL=0 -std=gnu++14@  ${common.build_flags} -DDEBUG_LEVEL=0 -std=gnu++14 -DHAVE_SW_SERIAL@' ${MARLIN_DIR}/platformio.ini



cp ${MARLIN_DIR}/config/examples/Creality/Ender-3/Configuration.h ${MARLIN_DIR}/Marlin
cp ${MARLIN_DIR}/config/examples/Creality/Ender-3/Configuration_adv.h ${MARLIN_DIR}/Marlin
cp ${MARLIN_DIR}/config/examples/Creality/Ender-3/_Bootscreen.h ${MARLIN_DIR}/Marlin
cp ${MARLIN_DIR}/config/examples/Creality/Ender-3/_Statusscreen.h ${MARLIN_DIR}/Marlin



sed -i 's@#define SERIAL_PORT .*@#define SERIAL_PORT 2@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@/*#define SERIAL_PORT_2 .*@#define SERIAL_PORT_2 -1@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@#define BAUDRATE .*@#define BAUDRATE 115200@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@ *#define MOTHERBOARD .*@  #define MOTHERBOARD BOARD_BTT_SKR_MINI_E3_V1_2@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@/*#define X_DRIVER_TYPE .*@#define X_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define Y_DRIVER_TYPE .*@#define Y_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define Z_DRIVER_TYPE .*@#define Z_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define E0_DRIVER_TYPE .*@#define E0_DRIVER_TYPE TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@/.*#define CR10_STOCKDISPLAY@#define CR10_STOCKDISPLAY@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@#define SPEAKER@//#define SPEAKER@' ${MARLIN_DIR}/Marlin/Configuration.h



# discovered from BigTreeTech reference firmware sources
sed -i 's@#if HAS_TMC220x && !defined(TARGET_LPC1768) && ENABLED(ENDSTOP_INTERRUPTS_FEATURE)@& \&\& !defined(TARGET_STM32F1)@g' ${MARLIN_DIR}/Marlin/src/inc/SanityCheck.h
sed -i 's@/*#define ENDSTOP_INTERRUPTS_FEATURE@#define ENDSTOP_INTERRUPTS_FEATURE@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@//#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define FAN_SOFT_PWM@#define FAN_SOFT_PWM@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define TMC_DEBUG@#define TMC_DEBUG@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# personal tweaks
sed -i 's@#define STRING_CONFIG_H_AUTHOR .*@#define STRING_CONFIG_H_AUTHOR "(SKR mini E3)"@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define CUSTOM_MACHINE_NAME .*@#define CUSTOM_MACHINE_NAME "SKR mini E3"@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define SHOW_BOOTSCREEN@//#define SHOW_BOOTSCREEN@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define SHOW_CUSTOM_BOOTSCREEN@//#define SHOW_CUSTOM_BOOTSCREEN@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define CUSTOM_STATUS_SCREEN_IMAGE@//#define CUSTOM_STATUS_SCREEN_IMAGE@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define LEVEL_BED_CORNERS@#define LEVEL_BED_CORNERS@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define S_CURVE_ACCELERATION@#define S_CURVE_ACCELERATION@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define LCD_SET_PROGRESS_MANUALLY@#define LCD_SET_PROGRESS_MANUALLY@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define DOGM_SD_PERCENT@  #define DOGM_SD_PERCENT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define FILAMENT_LOAD_UNLOAD_GCODES@  #define FILAMENT_LOAD_UNLOAD_GCODES  @' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define SENSORLESS_HOMING@  #define SENSORLESS_HOMING@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



(cd ${MARLIN_DIR}; ../${VENV_DIR}/bin/platformio run)



ls -lh ${MARLIN_DIR}/.pio/build/*/firmware.bin
