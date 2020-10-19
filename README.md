# BigTreeTech SKR-mini-E3 V1.2

> **USE THIS FIRMWARE AT YOUR OWN PERIL**
>
> These firmware builds no longer use the out of spec 512K flash, however, they do use the as of yet non-standard
> [newlib-nano](https://keithp.com/newlib-nano/) to keep the firmware sizes managable.
> More info [here](https://github.com/MarlinFirmware/Marlin/issues/19427).
>
> Make sure to watch
> [this](https://www.youtube.com/watch?v=VK_K6fp4BIk) and
> [this](https://www.youtube.com/watch?v=ckQ9UWlmdVA).
>
> If you're having issues updating your SKR-mini-E3 V1.2 firmware, try reformatting your SD card.
>
> If you're seeing unexpected behavior, please try resetting the Configuration to defaults.

## BLTouch (__REQUIRED__)

**CRITICAL:** The BLTouch bed levelling sensor should be connected to the `PROBE` (and `SERVO`) headers,
and triple check the actual pinouts before powering on the board.

**WARNING:** The `Z-STOP` header is ignored, as the BLTouch is effectively used as the Z-axis endstop.

**INFO:** The precompiled firmware.bin presumes the use of Creality's official metal mounting bracket,
resulting in sensor-to-nozzle offsets of roughly -43mm, -5mm, -2mm (X, Y, Z).

**INFO:** High Speed mode is enabled, therefore a BLTouch SMART 3.0 or higher may be required, and
compatibility with clone sensors may be reduced.

**INFO:** During print relative Babystepping is now regular absolute Z-Offset, which should making
dialing in the Z-Offset much easier.

**TIP:** The precompiled firmware.bin was tested using a genuine BLTouch SMART 3.1, if you are
getting inconsistent behavior, try adjusting the magnet inside the BLTouch using the hexnut
located in device's top center. Turning the hexnut 90 degrees clockwise fixed it for me.

## Important Notes

**CRITICAL:** The main tested firmware build is now configured for a Mini BMG extruder,
which required reversing of the extruder direction.

**CRITICAL:** Extended Y-axis range (12mm beyond bed) is used to increase automated bed levelling
coverage, and compatibility with third party hot-end shrouds may be reduced.

**CRITICAL:** X/Y Microstepping has been reverted to 16 (resulting in 80 steps/mm again).

**WARNING:** `Z_MAX_POS` has been limited to 220 to account for thicker print beds,
a BMG style extruder upgrade and a leadscrew top mount upgrade.

The status screen flow rate deadzone has been increased, so it's more difficult to
accidentally trigger flow rate changes from the status screen.

S-Curve acceleration is enabled.

Junction deviation has been reverted to traditional Jerk.

Supports remaining times, if enabled in your slicer software
([`M73`](http://marlinfw.org/docs/gcode/M073.html) G-code).

Nozzle Park is builtin
(you can use [`G27 P2`](http://marlinfw.org/docs/gcode/G027.html) in your print end G-code).

Trinamic StealthChop/SpreadCycle hybrid threshold is enabled
([`M913`](http://marlinfw.org/docs/gcode/M913.html) G-code).

Load/Unload Filament is builtin.
([`M702`](http://marlinfw.org/docs/gcode/M702.html) G-code).

Advanced Pause Feature is builtin, but is as of yet _untested_.
([`M600`](http://marlinfw.org/docs/gcode/M600.html) G-code).

Filament Runout Sensor is builtin, but is as of yet _untested_ and _disabled by default_
([`M412 S1`](http://marlinfw.org/docs/gcode/M412.html) G-code).

Power Loss Recovery is builtin, but is as of yet _untested_ and _disabled by default_
([`M413 S1`](http://marlinfw.org/docs/gcode/M413.html) G-code).

Maximum hot-end temperature has been limited to 250C for increased safety.

Maximum heated-bed temperature has been limited to 80C for increased safety.

Maximum filename length has been increased.

Hotend is listed as E0 (as opposed to E1) to match Marlin source configuration files.

## Using The Build Script

The build script has been tested on Xubuntu 20.04 LTS, some examples:

```
sudo apt-get install git python3-venv
bash skr_mini_e3_build.sh skrminie3v12 minibmg bltouch
bash skr_mini_e3_build.sh skrminie3v12 stock bltouch
bash skr_mini_e3_build.sh skrminie3v12 stock nobltouch 
bash skr_mini_e3_build.sh melzi stock nobltouch
```

## Initial Setup

After flashing the appropriate compiled firmware.bin, if desired, you should (re-)calibrate 
your extruder (E-steps) first.

Then run optionally run Hotend PID autotuning.

Next do a _bed level corners_, using a ~200gsm (~0.25mm) thick piece of paper.

Finally, attempt a trivial print, lowering the Z-Offset until you get good
bed adhesion, in my particular case I ended up somewhere around -2.00mm
(this is somewhat affected by nozzle wear).

## PrusaSlicer Printer Settings

* Bed shape: 231x231
* Max print height: 220
* Supports remaining times: ENABLE

## PrusaSlicer Start G-code

```
G90 ; use absolute coordinates
M83 ; extruder relative mode

M104 S150 ; set extruder temp for bed leveling
M140 S[first_layer_bed_temperature] ; set bed temp

G28 ; home all
G29 ; auto bed levelling

G1 X2 Y10 Z50 F3000 ; lift nozzle

M104 S[first_layer_temperature] ; set extruder temp
M190 S[first_layer_bed_temperature] ; wait for bed temp
M109 S[first_layer_temperature] ; wait for extruder temp

G1 X2 Y10 Z0.28 F240
G92 E0.0
G1 Y190 E11.0 F1500.0 ; intro line
G1 X2.3 F3600
G1 Y10 E11.0 F1200.0 ; intro line
G92 E0.0
```

## PrusaSlicer End G-code

```
M104 S0 ; turn off temperature
M140 S0 ; turn off heatbed
M107 ; turn off fan
G27 P2 ; Present print
M84 X Y E ; disable motors
```

## Reference platform

- [SKR-mini-E3 V1.2](https://github.com/bigtreetech/BIGTREETECH-SKR-mini-E3)
- [Creality Ender 3 Pro](https://www.creality.com/creality-ender-3-pro-3d-printer-p00251p1.html)
- [ANTCLABS BLTouch SMART 3.1 with the Creality metal mounting bracket](https://www.antclabs.com/bltouch-v3)
- [TriangleLab Dual Drive Extruder Mini BMG](https://nl.aliexpress.com/item/33029933418.html)
- [FYSETC Leadscrew Top Mount](https://aliexpress.com/item/33013348068.html)
- [Micro Swiss All Metal Hotend](https://store.micro-swiss.com/products/all-metal-hotend-kit-for-cr-10)
- [Capricorn TL Bowden Tubing](https://www.captubes.com/)
- [FlexPlate PEI Print Surface](https://primacreator.com/products/primacreator-flexplate-pei)
