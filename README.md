# BigTreeTech SKR-mini-E3 V1.2

**WARNING:** Firmware in this repository is provided as-is, **use at your own risk**.

**TIP:** If you're having issues updating your SKR mini E3 firmware, try reformatting your SD card.

## BLTouch (__REQUIRED__)

**CRITICAL:** The BLTouch bed levelling sensor should be connected to the `PROBE` (and `SERVO`) headers,
and triple check the actual pinouts before powering on the board.

**WARNING:** The `Z-STOP` header is ignored, as the BLTouch is effectively used as the Z-axis endstop.

**INFO:** `Z_MAX_POS` has been limited to 235, to account for thicker print beds.

**INFO:** The precompiled firmware.bin presumes the use of Creality's official metal mounting bracket,
resulting in sensor-to-nozzle offsets of roughly -44mm, -6mm, -2mm (X, Y, Z).

**TIP:** The precompiled firmware.bin was tested using a genuine BLTouch SMART 3.1, if you are
getting inconsistent behavior, try adjusting the magnet inside the BLTouch using the hexnut
located in device's top center. Turning the hexnut 90 degrees clockwise fixed it for me.

## Important Notes

Supports remaining times, if enabled in your slicer software (via `M73` G-code).

Nozzle Park is builtin (you can use `G27 P2` in your print end G-code).

Junction deviation is builtin and enabled with a more conservative default value.

Linear Advance is builtin and enabled by default and tuned for PLA @ 205C.
With Linear Advance enabled, you may want to slightly (5%) increase Infill/perimeter overlap in your slicer.

S-Curve acceleration is not available, as it's not fully compatible with Linear Advance.

Trinamic StealthChop/SpreadCycle hybrid threshold is enabled (tuneable via `M913` G-code).

Advanced Pause Feature is builtin, but is as of yet _untested_.

Filament Load/Unload is builtin, but is as of yet _untested_.

Filament Runout Sensor is builtin, but is as of yet _untested_
and _disabled by default_ (you can use `M412 S1` in your print start G-code).

Retuned hot-end PID loop.

Maximum hot-end temperature has been limited to 250C for increased safety.

Maximum heated-bed temperature has been limited to 80C for increased safety.

## Initial Setup

After flashing the precompiled firmware.bin, if desired, you should (re-)calibrate 
your extruder (E-steps) first. Keep in mind that Creality's default 93 E-steps
purposefully slightly underextrudes, which typically benefits your prints
optical quality.

Next do a _bed level corners_, using a ~200gsm (~0.25mm) thick piece of paper.

Finally, attempt a trivial print, lowering the Z-Offset until you get good
bed adhesion, in my particular case I ended up somewhere around -2.20mm.

## Example Start G-code for PrusaSlicer

```
G90 ; use absolute coordinates
M83 ; extruder relative mode

M104 S[first_layer_bed_temperature] ; set extruder temp
M140 S[first_layer_bed_temperature] ; set bed temp

G28 ; home all
G29 ; auto bed levelling (bltouch)

G1 X2 Y10 Z50 F3000 ; lift nozzle

M104 S[first_layer_temperature] ; set extruder temp
M190 S[first_layer_bed_temperature] ; wait for bed temp
M109 S[first_layer_temperature] ; wait for extruder temp

G1 X2 Y10 Z0.28 F240
G92 E0
G1 Y190 E15.0 F1500.0 ; intro line
G1 X2.3 F5000
G1 Y10 E30 F1200.0 ; intro line
G92 E0

G1 Z2.0 F3000 ; lift nozzle

```

## Example End G-code for PrusaSlicer

```
G1 E-3 F3600 ; release nozzle pressure
G27 P2 ; park toolhead and present print

M104 S[first_layer_temperature] ; raise extruder temp
G4 S45 ; allow the nozzle to release residual pressure through oozing

M104 S0 ; turn off temperature
M140 S0 ; turn off heatbed
M107 ; turn off fan
M84 X Y E ; disable motors
```

## Recommended printable upgrades

- [Ender 3 Cooling fan mod (CNC Kitchen)](https://www.thingiverse.com/thing:3437925)
