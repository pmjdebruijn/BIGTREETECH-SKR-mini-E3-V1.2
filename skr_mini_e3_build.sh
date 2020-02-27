#!/bin/sh
#
# SKR mini E3 V1.2  -  Marlin 2.0  -  firmware build script
#
# Copyright (c) 2019-2020 Pascal de Bruijn
#



BRANCH=2.0.x



VENV_DIR=PlatformIO
MARLIN_DIR=Marlin
CONFIG_DIR=Configurations



python3 -m venv ${VENV_DIR}

./${VENV_DIR}/bin/pip install -U platformio --no-cache-dir



git clone https://github.com/MarlinFirmware/Configurations ${CONFIG_DIR}
git clone https://github.com/MarlinFirmware/Marlin ${MARLIN_DIR}

git -C ${MARLIN_DIR} checkout ${BRANCH}

VERSION=$(git -C ${MARLIN_DIR} rev-parse HEAD | head -c 8)



sed -i 's@\[platformio\]@\[platformio\]\ncore_dir = PlatformIO@' ${MARLIN_DIR}/platformio.ini

sed -i 's@default_envs.*=.*@default_envs = STM32F103RC_bigtree_512K@' ${MARLIN_DIR}/platformio.ini



cp "${CONFIG_DIR}/config/examples/Creality/Ender-3/Configuration.h" "${MARLIN_DIR}/Marlin"
cp "${CONFIG_DIR}/config/examples/Creality/Ender-3/Configuration_adv.h" "${MARLIN_DIR}/Marlin"



git -C ${MARLIN_DIR} commit -a -m "$0: base example config"



# Configuration repository hasn't been updated yet
sed -i 's@#define CONFIGURATION_H_VERSION 020000@#define CONFIGURATION_H_VERSION 020004@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define CONFIGURATION_ADV_H_VERSION 020000@#define CONFIGURATION_ADV_H_VERSION 020004@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



sed -i 's@#define SERIAL_PORT .*@#define SERIAL_PORT 2@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@/*#define SERIAL_PORT_2 .*@#define SERIAL_PORT_2 -1@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@#define BAUDRATE .*@#define BAUDRATE 115200@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@ *#define MOTHERBOARD .*@  #define MOTHERBOARD BOARD_BTT_SKR_MINI_E3_V1_2@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@/*#define X_DRIVER_TYPE .*@#define X_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define Y_DRIVER_TYPE .*@#define Y_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define Z_DRIVER_TYPE .*@#define Z_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define E0_DRIVER_TYPE .*@#define E0_DRIVER_TYPE TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define SPEAKER@//#define SPEAKER@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define CR10_STOCKDISPLAY@#define CR10_STOCKDISPLAY@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define SDCARD_CONNECTION .*@    #define SDCARD_CONNECTION ONBOARD@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# discovered from BigTreeTech reference firmware sources
sed -i 's@/*#define ENDSTOP_INTERRUPTS_FEATURE@#define ENDSTOP_INTERRUPTS_FEATURE@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@//#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define FAN_SOFT_PWM@#define FAN_SOFT_PWM@' ${MARLIN_DIR}/Marlin/Configuration.h



# beware https://github.com/MarlinFirmware/Marlin/pull/16143
sed -i 's@.*#define SD_CHECK_AND_RETRY@#define SD_CHECK_AND_RETRY@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# center bed
sed -i 's@#define X_BED_SIZE .*@#define X_BED_SIZE 231@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define Y_BED_SIZE .*@#define Y_BED_SIZE 231@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define Z_MAX_POS .*@#define Z_MAX_POS 220@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define MANUAL_Y_HOME_POS .*@#define MANUAL_Y_HOME_POS -4@g' ${MARLIN_DIR}/Marlin/Configuration.h



# personal tweaks
sed -i 's@#define STRING_CONFIG_H_AUTHOR .*@#define STRING_CONFIG_H_AUTHOR "(SKR mini E3)"@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define CUSTOM_MACHINE_NAME .*@#define CUSTOM_MACHINE_NAME "SKR mini E3"@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@#define DEFAULT_MAX_FEEDRATE .*@#define DEFAULT_MAX_FEEDRATE          { 500, 500, 10, 80 }@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define SHOW_BOOTSCREEN@//#define SHOW_BOOTSCREEN@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define SHOW_CUSTOM_BOOTSCREEN@//#define SHOW_CUSTOM_BOOTSCREEN@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define CUSTOM_STATUS_SCREEN_IMAGE@//#define CUSTOM_STATUS_SCREEN_IMAGE@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define LEVEL_BED_CORNERS@#define LEVEL_BED_CORNERS@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define LEVEL_CORNERS_INSET.*@  #define LEVEL_CORNERS_INSET_LFRB { 31, 31, 31, 31 } @g' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define JUNCTION_DEVIATION_MM .*@  #define JUNCTION_DEVIATION_MM 0.04@g' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define S_CURVE_ACCELERATION@//#define S_CURVE_ACCELERATION@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define LIN_ADVANCE@#define LIN_ADVANCE@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define LIN_ADVANCE_K .*@  #define LIN_ADVANCE_K 0.0@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h

sed -i 's@.*#define ENDSTOPS_ALWAYS_ON_DEFAULT@#define ENDSTOPS_ALWAYS_ON_DEFAULT@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h

sed -i 's@.*#define INDIVIDUAL_AXIS_HOMING_MENU@//#define INDIVIDUAL_AXIS_HOMING_MENU@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define SQUARE_WAVE_STEPPING@  #define SQUARE_WAVE_STEPPING@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

sed -i 's@.*#define ARC_SUPPORT@#define ARC_SUPPORT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

sed -i 's@.*#define BLOCK_BUFFER_SIZE .*@  #define BLOCK_BUFFER_SIZE 32@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
#sed -i 's@.*#define BUFSIZE .*@#define BUFSIZE 32@' ${MARLIN_DIR}/Marlin/Configuration_adv.h        # PROBLEM
sed -i 's@.*#define TX_BUFFER_SIZE .*@#define TX_BUFFER_SIZE 32@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define LONG_FILENAME_HOST_SUPPORT@  #define LONG_FILENAME_HOST_SUPPORT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# tmc stepper driver hybrid stealthchop/spreadcycle
sed -i 's@.*#define HYBRID_THRESHOLD@  #define HYBRID_THRESHOLD@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h

sed -i 's@.*#define X_HYBRID_THRESHOLD .*@  #define X_HYBRID_THRESHOLD     160@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define Y_HYBRID_THRESHOLD .*@  #define Y_HYBRID_THRESHOLD     160@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define Z_HYBRID_THRESHOLD .*@  #define Z_HYBRID_THRESHOLD      30@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define E0_HYBRID_THRESHOLD .*@  #define E0_HYBRID_THRESHOLD     30@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h

sed -i 's@.*#define MONITOR_DRIVER_STATUS@  #define MONITOR_DRIVER_STATUS@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# tmc microstepping
sed -i 's@.*#define DEFAULT_AXIS_STEPS_PER_UNIT .*@#define DEFAULT_AXIS_STEPS_PER_UNIT   { 160, 160, 400, 93 }@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define X_MICROSTEPS .*@    #define X_MICROSTEPS     32@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define Y_MICROSTEPS .*@    #define Y_MICROSTEPS     32@' ${MARLIN_DIR}/Marlin/Configuration_adv.h




# sorting
sed -i 's@.*#define SDCARD_SORT_ALPHA@  #define SDCARD_SORT_ALPHA@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define SDSORT_USES_RAM .*@    #define SDSORT_USES_RAM    true@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define SDSORT_CACHE_NAMES .*@    #define SDSORT_CACHE_NAMES true@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# lcd tweaks
sed -i 's@.*#define DOGM_SD_PERCENT@  #define DOGM_SD_PERCENT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define LCD_SET_PROGRESS_MANUALLY@#define LCD_SET_PROGRESS_MANUALLY@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define SHOW_REMAINING_TIME@  #define SHOW_REMAINING_TIME@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define USE_M73_REMAINING_TIME@    #define USE_M73_REMAINING_TIME@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define ROTATE_PROGRESS_DISPLAY@    #define ROTATE_PROGRESS_DISPLAY@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# nozzle parking
sed -i 's@.*#define NOZZLE_PARK_FEATURE@#define NOZZLE_PARK_FEATURE@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define NOZZLE_PARK_POINT .*@  #define NOZZLE_PARK_POINT { 5, 175, 100 }@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define EVENT_GCODE_SD_STOP .*@  #define EVENT_GCODE_SD_STOP "G91\\nG1 Z1 E-3 F2400\\nG27 P2"@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# advanced pause (for multicolor)
sed -i 's@.*#define EXTRUDE_MAXLENGTH .*@#define EXTRUDE_MAXLENGTH 500@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define ADVANCED_PAUSE_FEATURE@#define ADVANCED_PAUSE_FEATURE@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define PAUSE_PARK_RETRACT_FEEDRATE .*@  #define PAUSE_PARK_RETRACT_FEEDRATE         40@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define PAUSE_PARK_RETRACT_LENGTH .*@  #define PAUSE_PARK_RETRACT_LENGTH            6@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define FILAMENT_CHANGE_UNLOAD_FEEDRATE .*@  #define FILAMENT_CHANGE_UNLOAD_FEEDRATE     20@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define FILAMENT_CHANGE_UNLOAD_LENGTH .*@  #define FILAMENT_CHANGE_UNLOAD_LENGTH      470@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define FILAMENT_CHANGE_FAST_LOAD_FEEDRATE .*@  #define FILAMENT_CHANGE_FAST_LOAD_FEEDRATE  20@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define FILAMENT_CHANGE_FAST_LOAD_LENGTH .*@  #define FILAMENT_CHANGE_FAST_LOAD_LENGTH   370@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define ADVANCED_PAUSE_PURGE_LENGTH .*@  #define ADVANCED_PAUSE_PURGE_LENGTH        100@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define PARK_HEAD_ON_PAUSE@  #define PARK_HEAD_ON_PAUSE@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define FILAMENT_LOAD_UNLOAD_GCODES@  #define FILAMENT_LOAD_UNLOAD_GCODES@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# firmware based retraction support
sed -i 's@.*//#define FWRETRACT@#define FWRETRACT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define RETRACT_LENGTH .*@  #define RETRACT_LENGTH 6@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define RETRACT_FEEDRATE .*@  #define RETRACT_FEEDRATE 40@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# filament runout sensor (but disabled by default)
sed -i 's@.*#define FILAMENT_RUNOUT_SENSOR@#define FILAMENT_RUNOUT_SENSOR@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*runout.enabled = true@    runout.enabled = false@g' ${MARLIN_DIR}/Marlin/src/module/configuration_store.cpp



# make sure bed pid temp remains disabled, to keep compatibility with flex-steel pei
sed -i 's@.*#define PIDTEMPBED@//#define PIDTEMPBED@' ${MARLIN_DIR}/Marlin/Configuration.h



# add a little more safety, limits selectable temp to 10 degrees less
sed -i 's@#define BED_MAXTEMP .*@#define BED_MAXTEMP      90@g' ${MARLIN_DIR}/Marlin/Configuration.h



# add a little more safety, limits selectable temp to 15 degrees less
sed -i 's@#define HEATER_0_MAXTEMP 275@#define HEATER_0_MAXTEMP 265@g' ${MARLIN_DIR}/Marlin/Configuration.h



# modernize pla preset
sed -i 's@#define PREHEAT_1_TEMP_HOTEND .*@#define PREHEAT_1_TEMP_HOTEND 200@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define PREHEAT_1_TEMP_BED .*@#define PREHEAT_1_TEMP_BED     60@g' ${MARLIN_DIR}/Marlin/Configuration.h



# change abs preset to petg
sed -i 's@#define PREHEAT_2_LABEL .*@#define PREHEAT_2_LABEL       "PETG"@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define PREHEAT_2_TEMP_HOTEND .*@#define PREHEAT_2_TEMP_HOTEND 240@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define PREHEAT_2_TEMP_BED .*@#define PREHEAT_2_TEMP_BED     70@g' ${MARLIN_DIR}/Marlin/Configuration.h



# bltouch probe on probe connector
sed -i 's@.*#define MESH_BED_LEVELING@//#define MESH_BED_LEVELING@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define BLTOUCH@#define BLTOUCH@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define LCD_BED_LEVELING@#define LCD_BED_LEVELING@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define AUTO_BED_LEVELING_BILINEAR@#define AUTO_BED_LEVELING_BILINEAR@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define GRID_MAX_POINTS_X .*@  #define GRID_MAX_POINTS_X 3@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define NOZZLE_TO_PROBE_OFFSET .*@#define NOZZLE_TO_PROBE_OFFSET { -43, -5, 0 }@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define MIN_PROBE_EDGE .*@#define MIN_PROBE_EDGE 43@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define EXTRAPOLATE_BEYOND_GRID@#define EXTRAPOLATE_BEYOND_GRID@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define BABYSTEP_MULTIPLICATOR_Z .*@  #define BABYSTEP_MULTIPLICATOR_Z 5@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define BABYSTEP_MULTIPLICATOR_XY .*@  #define BABYSTEP_MULTIPLICATOR_XY 5@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# bltouch probe as z-endstop on z-endstop connector
sed -i 's@/*#define Z_SAFE_HOMING@#define Z_SAFE_HOMING@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@' ${MARLIN_DIR}/Marlin/Configuration.h



# use probe connector as z-endstop connector
sed -i 's@.*#define Z_STOP_PIN.*@#define Z_STOP_PIN         PC14@g' ${MARLIN_DIR}/Marlin/src/pins/stm32/pins_BTT_SKR_MINI_E3.h



# debugging
#sed -i 's@/*#define MIN_SOFTWARE_ENDSTOP_Z@//#define MIN_SOFTWARE_ENDSTOP_Z@' ${MARLIN_DIR}/Marlin/Configuration.h
#sed -i 's@/*#define DEBUG_LEVELING_FEATURE@#define DEBUG_LEVELING_FEATURE@g' ${MARLIN_DIR}/Marlin/Configuration.h
#sed -i 's@.*#define TMC_DEBUG@  #define TMC_DEBUG@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



(cd ${MARLIN_DIR}; ../${VENV_DIR}/bin/platformio run)

grep 'STRING_DISTRIBUTION_DATE.*"' ${MARLIN_DIR}/Marlin/src/inc/Version.h

ls -lh ${MARLIN_DIR}/.pio/build/*/firmware.bin

