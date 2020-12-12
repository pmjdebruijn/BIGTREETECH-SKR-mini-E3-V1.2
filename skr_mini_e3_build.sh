#!/bin/sh
#
# SKR mini E3 V1.2  -  Marlin 2.0  -  firmware build script
#
# Copyright (c) 2019-2020 Pascal de Bruijn
#



VENV_DIR=PlatformIO
MARLIN_DIR=Marlin
CONFIG_DIR=Configurations
CONFIG_BASE='Creality/Ender-3 Pro/CrealityV1'



SRC_BRANCH=3404cb1fc4eced0f608cdea4e752e20daf9f9112 #bugfix-2.0.x
CFG_BRANCH=c92c1b844e3e9fa0646176681f908c2ea4a904c7 #import-2.0.x



BOARD=$1
[ "${BOARD}" == "" ] && BOARD=skrminie3v12 && echo "WARNING: Board not specified, defaulting to '${BOARD}' ..."

EXTRUDER=$2
[ "${EXTRUDER}" == "" ] && EXTRUDER=minibmg && echo "WARNING: Extruder not specified, defaulting to '${EXTRUDER}' ..."

SENSOR=$3
[ "${SENSOR}" == "" ] && SENSOR=bltouch && echo "WARNING: Sensor not specified, defaulting to '${SENSOR}' ..."



if [ ! -d "${VENV_DIR}" ]; then
  python3 -m venv ${VENV_DIR}

  ./${VENV_DIR}/bin/pip install -U wheel --no-cache-dir
  ./${VENV_DIR}/bin/pip install -U platformio --no-cache-dir
else
  echo "WARNING: Reusing preexisting ${VENV_DIR} directory..."
fi

if [ ! -d "${CONFIG_DIR}" ]; then
  git clone https://github.com/MarlinFirmware/Configurations ${CONFIG_DIR}

  git -C ${CONFIG_DIR} checkout ${CFG_BRANCH}
else
  echo "WARNING: Reusing preexisting ${CONFIG_DIR} directory..."
fi

if [ ! -d "${MARLIN_DIR}" ]; then
  git clone https://github.com/MarlinFirmware/Marlin ${MARLIN_DIR}

  git -C ${MARLIN_DIR} checkout ${SRC_BRANCH}

  cp "${CONFIG_DIR}/config/examples/${CONFIG_BASE}/Configuration.h" "${MARLIN_DIR}/Marlin"
  cp "${CONFIG_DIR}/config/examples/${CONFIG_BASE}/Configuration_adv.h" "${MARLIN_DIR}/Marlin"
  cp "${CONFIG_DIR}/config/examples/${CONFIG_BASE}/_Statusscreen.h" "${MARLIN_DIR}/Marlin"
  cp "${CONFIG_DIR}/config/examples/${CONFIG_BASE}/_Bootscreen.h" "${MARLIN_DIR}/Marlin"

  git -C ${MARLIN_DIR} add Marlin/_Statusscreen.h
  git -C ${MARLIN_DIR} add Marlin/_Bootscreen.h

  git -C ${MARLIN_DIR} commit --all --message "$0: ${CONFIG_BASE} example config"
else
  echo "WARNING: Reusing preexisting ${MARLIN_DIR} directory..."
fi



git -C ${MARLIN_DIR} reset --hard



sed -i 's@[Mm]edia@TF card@g' ${MARLIN_DIR}/Marlin/src/lcd/language/language_en.h
sed -i 's@SD Init Fail@TF card init fail@g' ${MARLIN_DIR}/Marlin/src/lcd/language/language_en.h

sed -i 's@\[platformio\]@\[platformio\]\ncore_dir = PlatformIO@' ${MARLIN_DIR}/platformio.ini

sed -i 's@.*#define CUSTOM_VERSION_FILE.*@&\n#define WEBSITE_URL "www.creality3d.cn"@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@#define STRING_CONFIG_H_AUTHOR .*@#define STRING_CONFIG_H_AUTHOR "Ender-3 Pro"@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define CUSTOM_MACHINE_NAME .*@#define CUSTOM_MACHINE_NAME "Ender-3 Pro"@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define MACHINE_UUID .*@#define MACHINE_UUID "0c0f870d-9d03-4bed-b217-9195f1f3941e"@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define BOOTSCREEN_TIMEOUT .*@#define BOOTSCREEN_TIMEOUT 1000@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@show_marlin_bootscreen();@//show_marlin_bootscreen();@' ${MARLIN_DIR}/Marlin/src/lcd/dogm/marlinui_DOGM.cpp

sed -i 's@.*#define LCD_TIMEOUT_TO_STATUS .*@#define LCD_TIMEOUT_TO_STATUS 90000@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

sed -i 's@.*#define LEVEL_BED_CORNERS@#define LEVEL_BED_CORNERS@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define LEVEL_CORNERS_INSET.*@  #define LEVEL_CORNERS_INSET_LFRB { 31, 31, 31, 31 }@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define DEFAULT_MAX_ACCELERATION .*@#define DEFAULT_MAX_ACCELERATION      { 500, 500, 100, 1000 }@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define DEFAULT_TRAVEL_ACCELERATION .*@#define DEFAULT_TRAVEL_ACCELERATION   1000@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define CLASSIC_JERK@#define CLASSIC_JERK@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define DEFAULT_XJERK .*@   #define DEFAULT_XJERK 8.0@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define DEFAULT_YJERK .*@   #define DEFAULT_YJERK 8.0@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define S_CURVE_ACCELERATION@#define S_CURVE_ACCELERATION@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define INDIVIDUAL_AXIS_HOMING_MENU@//#define INDIVIDUAL_AXIS_HOMING_MENU@' ${MARLIN_DIR}/Marlin/Configuration.h

# limit z height
sed -i 's@#define Z_MAX_POS .*@#define Z_MAX_POS 220@' ${MARLIN_DIR}/Marlin/Configuration.h

# fix bed center
sed -i 's@#define X_MAX_POS .*@#define X_MAX_POS 243 // for BLTouch@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define Y_MIN_POS .*@#define Y_MIN_POS -6@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define X_BED_SIZE .*@#define X_BED_SIZE 231@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define Y_BED_SIZE .*@#define Y_BED_SIZE 231@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@.*#define NO_WORKSPACE_OFFSETS@#define NO_WORKSPACE_OFFSETS@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

# faster Z manual move
sed -i 's@#define MANUAL_FEEDRATE .*@#define MANUAL_FEEDRATE { 50*60, 50*60, 10*60, 2*60 }@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

# align to half step
sed -i 's@#define SHORT_MANUAL_Z_MOVE .*@#define SHORT_MANUAL_Z_MOVE 0.02@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

# beware https://github.com/MarlinFirmware/Marlin/pull/16143
sed -i 's@.*#define SD_CHECK_AND_RETRY@#define SD_CHECK_AND_RETRY@' ${MARLIN_DIR}/Marlin/Configuration.h

# lcd tweaks
sed -i '$ a #define NUMBER_TOOLS_FROM_0' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define ENCODER_FEEDRATE_DEADZONE .*@  #define ENCODER_FEEDRATE_DEADZONE 12@' ${MARLIN_DIR}/Marlin/src/inc/Conditionals_LCD.h
sed -i 's@.*#define DOGM_SD_PERCENT@  #define DOGM_SD_PERCENT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define LCD_SET_PROGRESS_MANUALLY@#define LCD_SET_PROGRESS_MANUALLY@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define SHOW_REMAINING_TIME@  #define SHOW_REMAINING_TIME@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define USE_M73_REMAINING_TIME@    #define USE_M73_REMAINING_TIME@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*if (blink \&\& estimation_string@          if (estimation_string@' ${MARLIN_DIR}/Marlin/src/lcd/dogm/status_screen_DOGM.cpp

# firmware based retraction support
sed -i 's@.*#define FWRETRACT@#define FWRETRACT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define FWRETRACT_AUTORETRACT@  //#define FWRETRACT_AUTORETRACT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define RETRACT_LENGTH .*@  #define RETRACT_LENGTH 3@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define RETRACT_FEEDRATE .*@  #define RETRACT_FEEDRATE 25@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define RETRACT_RECOVER_FEEDRATE .*@  #define RETRACT_RECOVER_FEEDRATE 25@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

# nozzle parking
sed -i 's@.*#define NOZZLE_PARK_FEATURE@#define NOZZLE_PARK_FEATURE@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define NOZZLE_PARK_POINT .*@  #define NOZZLE_PARK_POINT { 40, 170, 100 }@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define EVENT_GCODE_SD_ABORT .*@  #define EVENT_GCODE_SD_ABORT "G27 P2"@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

# make sure our Z doesn't drop down
sed -i 's@.*#define DISABLE_INACTIVE_Z .*@#define DISABLE_INACTIVE_Z false@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

# prevent filament cooking
sed -i 's@.*#define HOTEND_IDLE_TIMEOUT@#define HOTEND_IDLE_TIMEOUT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define HOTEND_IDLE_MIN_TRIGGER .*@  #define HOTEND_IDLE_MIN_TRIGGER   170@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define CONTROLLERFAN_IDLE_TIME .*@  #define CONTROLLERFAN_IDLE_TIME (5*60)@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

# make sure bed pid temp remains disabled, to keep compatibility with flex-steel pei
sed -i 's@.*#define PIDTEMPBED@//#define PIDTEMPBED@' ${MARLIN_DIR}/Marlin/Configuration.h

# add a little more safety, limits selectable temp to 10 degrees less
sed -i 's@#define BED_MAXTEMP .*@#define BED_MAXTEMP      90@' ${MARLIN_DIR}/Marlin/Configuration.h

# add a little more safety, limits selectable temp to 15 degrees less
sed -i 's@#define HEATER_0_MAXTEMP 275@#define HEATER_0_MAXTEMP 265@' ${MARLIN_DIR}/Marlin/Configuration.h

# modernize pla preset
sed -i 's@#define PREHEAT_1_TEMP_HOTEND .*@#define PREHEAT_1_TEMP_HOTEND 200@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define PREHEAT_1_TEMP_BED .*@#define PREHEAT_1_TEMP_BED     60@' ${MARLIN_DIR}/Marlin/Configuration.h

# change abs preset to petg
sed -i 's@#define PREHEAT_2_LABEL .*@#define PREHEAT_2_LABEL       "PETG"@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define PREHEAT_2_TEMP_HOTEND .*@#define PREHEAT_2_TEMP_HOTEND 240@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define PREHEAT_2_TEMP_BED .*@#define PREHEAT_2_TEMP_BED     70@' ${MARLIN_DIR}/Marlin/Configuration.h

# convenience
sed -i 's@/*#define BROWSE_MEDIA_ON_INSERT@#define BROWSE_MEDIA_ON_INSERT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

# disable arc support to save space
sed -i 's@.*#define ARC_SUPPORT@//#define ARC_SUPPORT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



if [ "${BOARD}" == "melzi" ]; then

  sed -i 's@default_envs.*=.*@default_envs = melzi_optimized@' ${MARLIN_DIR}/platformio.ini

  # sorting (16k ram)
  sed -i 's@.*#define SDCARD_SORT_ALPHA@  #define SDCARD_SORT_ALPHA@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_LIMIT .*@     #define SDSORT_LIMIT       50@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define FOLDER_SORTING .*@     #define FOLDER_SORTING     1@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_USES_RAM .*@    #define SDSORT_USES_RAM    true@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_CACHE_NAMES .*@    #define SDSORT_CACHE_NAMES true@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_CACHE_VFATS .*@    #define SDSORT_CACHE_VFATS 4@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

fi



if [ "${BOARD}" == "mksgenl" ]; then

  sed -i 's@default_envs.*=.*@default_envs = mega2560@' ${MARLIN_DIR}/platformio.ini

  sed -i 's@ *#define MOTHERBOARD .*@  #define MOTHERBOARD BOARD_MKS_GEN_L@' ${MARLIN_DIR}/Marlin/Configuration.h

  sed -i 's@.*#define CR10_STOCKDISPLAY@//#define CR10_STOCKDISPLAY@' ${MARLIN_DIR}/Marlin/Configuration.h
  sed -i 's@.*#define REPRAP_DISCOUNT_FULL_GRAPHIC_SMART_CONTROLLER@#define REPRAP_DISCOUNT_FULL_GRAPHIC_SMART_CONTROLLER@' ${MARLIN_DIR}/Marlin/Configuration.h
  sed -i 's@.*#define REVERSE_ENCODER_DIRECTION@#define REVERSE_ENCODER_DIRECTION@' ${MARLIN_DIR}/Marlin/Configuration.h
  sed -i 's@.*#define REVERSE_MENU_DIRECTION@#define REVERSE_MENU_DIRECTION@' ${MARLIN_DIR}/Marlin/Configuration.h
  sed -i 's@.*#define REVERSE_SELECT_DIRECTION@#define REVERSE_SELECT_DIRECTION@' ${MARLIN_DIR}/Marlin/Configuration.h

  # sorting (8k ram)
  sed -i 's@.*#define SDCARD_SORT_ALPHA@  #define SDCARD_SORT_ALPHA@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define FOLDER_SORTING .*@     #define FOLDER_SORTING     1@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_USES_RAM .*@    #define SDSORT_USES_RAM    true@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_CACHE_NAMES .*@    #define SDSORT_CACHE_NAMES true@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_CACHE_VFATS .*@    #define SDSORT_CACHE_VFATS 3@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

fi



if [ "${BOARD}" == "skrminie3v12" ]; then

  sed -i 's@default_envs.*=.*@default_envs = STM32F103RC_btt@' ${MARLIN_DIR}/platformio.ini

  sed -i 's@#define SERIAL_PORT .*@#define SERIAL_PORT 2@' ${MARLIN_DIR}/Marlin/Configuration.h

  sed -i 's@/*#define SERIAL_PORT_2 .*@#define SERIAL_PORT_2 -1@' ${MARLIN_DIR}/Marlin/Configuration.h

  sed -i 's@#define BAUDRATE .*@#define BAUDRATE 115200@' ${MARLIN_DIR}/Marlin/Configuration.h

  sed -i 's@ *#define MOTHERBOARD .*@  #define MOTHERBOARD BOARD_BTT_SKR_MINI_E3_V1_2@' ${MARLIN_DIR}/Marlin/Configuration.h

  sed -i 's@.*#define EMERGENCY_PARSER@#define EMERGENCY_PARSER@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

  sed -i 's@/*#define X_DRIVER_TYPE .*@#define X_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
  sed -i 's@/*#define Y_DRIVER_TYPE .*@#define Y_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
  sed -i 's@/*#define Z_DRIVER_TYPE .*@#define Z_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
  sed -i 's@/*#define E0_DRIVER_TYPE .*@#define E0_DRIVER_TYPE TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h

  sed -i 's@.*#define MONITOR_DRIVER_STATUS@  #define MONITOR_DRIVER_STATUS@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

  sed -i 's@.*#define ADAPTIVE_STEP_SMOOTHING@#define ADAPTIVE_STEP_SMOOTHING@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

  sed -i 's@.*#define HYBRID_THRESHOLD@  #define HYBRID_THRESHOLD@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define X_HYBRID_THRESHOLD .*@  #define X_HYBRID_THRESHOLD     150@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define Y_HYBRID_THRESHOLD .*@  #define Y_HYBRID_THRESHOLD     150@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define Z_HYBRID_THRESHOLD .*@  #define Z_HYBRID_THRESHOLD      10@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define E0_HYBRID_THRESHOLD .*@  #define E0_HYBRID_THRESHOLD     10@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

  sed -i 's@.*#define TMC_DEBUG@  #define TMC_DEBUG@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

  sed -i 's@.*#define SQUARE_WAVE_STEPPING@  #define SQUARE_WAVE_STEPPING@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

  sed -i 's@.*#define SPEAKER@//#define SPEAKER@' ${MARLIN_DIR}/Marlin/Configuration.h

  sed -i 's@.*#define CR10_STOCKDISPLAY@#define CR10_STOCKDISPLAY@' ${MARLIN_DIR}/Marlin/Configuration.h

  sed -i 's@.*#define SDCARD_CONNECTION .*@    #define SDCARD_CONNECTION ONBOARD@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

  # sorting (48k ram)
  sed -i 's@.*#define SDCARD_SORT_ALPHA@  #define SDCARD_SORT_ALPHA@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_LIMIT .*@     #define SDSORT_LIMIT      100@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define FOLDER_SORTING .*@     #define FOLDER_SORTING     1@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_USES_RAM .*@    #define SDSORT_USES_RAM    true@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_CACHE_NAMES .*@    #define SDSORT_CACHE_NAMES true@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define SDSORT_CACHE_VFATS .*@    #define SDSORT_CACHE_VFATS 4@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

fi



if [ "${BOARD}" != "melzi" ]; then

  sed -i 's@.*#define LONG_FILENAME_HOST_SUPPORT@  #define LONG_FILENAME_HOST_SUPPORT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

  # advanced pause (for multicolor)
  sed -i 's@.*#define EXTRUDE_MAXLENGTH .*@#define EXTRUDE_MAXLENGTH 500@' ${MARLIN_DIR}/Marlin/Configuration.h
  sed -i 's@.*#define ADVANCED_PAUSE_FEATURE@#define ADVANCED_PAUSE_FEATURE@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define PAUSE_PARK_RETRACT_FEEDRATE .*@  #define PAUSE_PARK_RETRACT_FEEDRATE         25@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define PAUSE_PARK_RETRACT_LENGTH .*@  #define PAUSE_PARK_RETRACT_LENGTH              3@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define FILAMENT_CHANGE_UNLOAD_FEEDRATE .*@  #define FILAMENT_CHANGE_UNLOAD_FEEDRATE     15@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define FILAMENT_CHANGE_UNLOAD_LENGTH .*@  #define FILAMENT_CHANGE_UNLOAD_LENGTH      470@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define FILAMENT_CHANGE_FAST_LOAD_FEEDRATE .*@  #define FILAMENT_CHANGE_FAST_LOAD_FEEDRATE  15@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define FILAMENT_CHANGE_FAST_LOAD_LENGTH .*@  #define FILAMENT_CHANGE_FAST_LOAD_LENGTH   370@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define ADVANCED_PAUSE_PURGE_LENGTH .*@  #define ADVANCED_PAUSE_PURGE_LENGTH        150@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define FILAMENT_UNLOAD_PURGE_LENGTH .*@  #define FILAMENT_UNLOAD_PURGE_LENGTH         4@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define PARK_HEAD_ON_PAUSE@  #define PARK_HEAD_ON_PAUSE@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define FILAMENT_LOAD_UNLOAD_GCODES@  #define FILAMENT_LOAD_UNLOAD_GCODES@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

  # filament runout sensor (but disabled by default)
  sed -i 's@.*#define FILAMENT_RUNOUT_SENSOR@#define FILAMENT_RUNOUT_SENSOR@' ${MARLIN_DIR}/Marlin/Configuration.h
  sed -i 's@.*#define FIL_RUNOUT_ENABLED_DEFAULT .*@  #define FIL_RUNOUT_ENABLED_DEFAULT false@' ${MARLIN_DIR}/Marlin/Configuration.h

  # Power Loss Recovery (but disabled by default)
  sed -i 's@#define SDCARD_READONLY@//#define SDCARD_READONLY@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define POWER_LOSS_RECOVERY@  #define POWER_LOSS_RECOVERY@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
  sed -i 's@.*#define PLR_ENABLED_DEFAULT.*@    #define PLR_ENABLED_DEFAULT   false // Power Loss Recovery disabled by default@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

  if [ "${SENSOR}" == "bltouch" ]; then

    # z-offset wizard
    sed -i 's@/*#define PROBE_OFFSET_WIZARD@#define PROBE_OFFSET_WIZARD@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
    sed -i 's@#define PROBE_OFFSET_START .*@#define PROBE_OFFSET_START -4.0@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

    # bltouch probe on probe connector
    sed -i 's@.*#define MESH_BED_LEVELING@//#define MESH_BED_LEVELING@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@/*#define BLTOUCH@#define BLTOUCH@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@/*#define LCD_BED_LEVELING@#define LCD_BED_LEVELING@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@/*#define AUTO_BED_LEVELING_BILINEAR@#define AUTO_BED_LEVELING_BILINEAR@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@.*#define GRID_MAX_POINTS_X .*@  #define GRID_MAX_POINTS_X 3@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@/*#define NOZZLE_TO_PROBE_OFFSET .*@#define NOZZLE_TO_PROBE_OFFSET { -43, -5, 0 }@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@/*#define PROBING_MARGIN .*@#define PROBING_MARGIN 31@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@/*#define EXTRAPOLATE_BEYOND_GRID@#define EXTRAPOLATE_BEYOND_GRID@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@/*#define BABYSTEP_MILLIMETER_UNITS@#define BABYSTEP_MILLIMETER_UNITS@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
    sed -i 's@.*#define BABYSTEP_MULTIPLICATOR_Z .*@  #define BABYSTEP_MULTIPLICATOR_Z  0.01@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
    sed -i 's@.*#define BABYSTEP_DISPLAY_TOTAL@  #define BABYSTEP_DISPLAY_TOTAL@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
    sed -i 's@.*#define BABYSTEP_ZPROBE_OFFSET@  #define BABYSTEP_ZPROBE_OFFSET@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
    sed -i 's@.*#define BABYSTEP_ZPROBE_GFX_OVERLAY@    #define BABYSTEP_ZPROBE_GFX_OVERLAY@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

    sed -i 's@.*#define XY_PROBE_SPEED .*@#define XY_PROBE_SPEED 9000@' ${MARLIN_DIR}/Marlin/Configuration.h

    sed -i 's@.*#define HOMING_FEEDRATE_Z .*@#define HOMING_FEEDRATE_Z  (10*60)@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@.*#define BLTOUCH_HS_MODE@  #define BLTOUCH_HS_MODE@' ${MARLIN_DIR}/Marlin/Configuration_adv.h

    sed -i 's@.*#define Z_CLEARANCE_DEPLOY_PROBE .*@#define Z_CLEARANCE_DEPLOY_PROBE   10@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@.*#define Z_AFTER_PROBING .*@#define Z_AFTER_PROBING            10@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@.*#define Z_HOMING_HEIGHT .*@#define Z_HOMING_HEIGHT 10@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@.*#define Z_AFTER_HOMING .*@#define Z_AFTER_HOMING  10@' ${MARLIN_DIR}/Marlin/Configuration.h

    # bltouch probe as z-endstop on z-endstop connector
    sed -i 's@/*#define Z_SAFE_HOMING@#define Z_SAFE_HOMING@' ${MARLIN_DIR}/Marlin/Configuration.h
    sed -i 's@/*#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@' ${MARLIN_DIR}/Marlin/Configuration.h

    # use probe connector as z-endstop connector
    sed -i 's@.*#define Z_STOP_PIN.*@#define Z_STOP_PIN                          PC14  // "Z-STOP" (BLTouch)@' ${MARLIN_DIR}/Marlin/src/pins/stm32f1/pins_BTT_SKR_MINI_E3_common.h

  fi

fi



if [ "${EXTRUDER}" == "minibmg" ]; then
  sed -i 's@.*#define INVERT_E0_DIR .*@#define INVERT_E0_DIR false@' ${MARLIN_DIR}/Marlin/Configuration.h
  sed -i 's@.*#define DEFAULT_AXIS_STEPS_PER_UNIT .*@#define DEFAULT_AXIS_STEPS_PER_UNIT   { 80, 80, 400, 141 }@' ${MARLIN_DIR}/Marlin/Configuration.h
fi



(cd ${MARLIN_DIR}; ../${VENV_DIR}/bin/platformio run)

grep 'STRING_DISTRIBUTION_DATE.*"' ${MARLIN_DIR}/Marlin/src/inc/Version.h

ls -lh ${MARLIN_DIR}/.pio/build/*/firmware.*



if [ "${BOARD}" != "skrminie3v12" ] || [ "${EXTRUDER}" != "minibmg" ] || [ "${SENSOR}" != "bltouch" ]; then
  echo "WARNING: Untested build configuration '${BOARD}/${EXTRUDER}/${SENSOR}' ..."
fi
