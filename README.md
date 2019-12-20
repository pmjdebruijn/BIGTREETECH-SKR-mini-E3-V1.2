# BigTreeTech SKR-mini-E3 V1.2

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

## Miscellaneous Notes

Supports remaining times, if enabled in your slicer software (via `M73` G-code).

Nozzle Park is builtin (you can use `G27 P2` in your print end G-code).

Junction deviation is builtin and enabled with a more conservative default value.

Linear Advance is builtin and enabled by default and tuned for PLA @ 205C.
With Linear Advance enabled, you may want to slightly (5%) increase Infill/perimeter overlap in your slicer.

S-Curve acceleration is not available, as it's not fully compatible with Linear Advance.

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
