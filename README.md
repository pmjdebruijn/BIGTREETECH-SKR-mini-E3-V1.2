# BigTreeTech SKR-mini-E3 V1.2

## BLTouch (__REQUIRED__)

The BLTouch bed levelling sensor should be connected to the PROBE (and SERVO) headers,
the precompiled firmware.bin presumes the use of Creality's official metal mounting bracket.

**WARNING:** The Z-STOP header is ignored, as the BLTouch is effectively used as an endstop.

**WARNING:** Z_MAX_POS has been limited to 240, to account for thicker print beds.

The precompiled firmware.bin was tested using a BLTouch SMART 3.1, if you are getting
inconsistent behavior, try adjusting the magnet inside the BLTouch using the hexnut
located in device's top center. Turning the hexnut 90 degrees clockwise fixed it for me.

## Miscellaneous Notes

Nozzle Park is enabled (you can use 'G27 P2' in your print end gcode)

Junction deviation is enabled, with a more conservative default value.

Linear Advance is enabled by default and tuned for PLA @ 205C.

S-Curve acceleration is disabled, as it's not fully compatible with Linear Advance.

Maximum bed temperature has been limited to 80C for increased safety.

Maximum nozzle temperature has been limited to 250C for increased safety.

## Initial Setup

After flashing the precompiled firmware.bin, if desired, you should (re-)calibrate 
your extruder first.

Next do a _bed level corners_, using a ~200gsm (~0.25mm) thick piece of paper.

Finally, attempt a trivial print, lowering the Z-Offset until you get good
bed adhesion, in my particular case I ended up somewhere around -2.20mm.
