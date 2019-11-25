# BigTreeTech SKR-mini-E3 V1.2

> **WARNING:** 
> The firmware.bin supplied in this repository requires the use of the extended
> 512KB of flash seemingly available on most of these boards. The second
> 256KB half is that flash is officially out of spec, and therefore maybe
> more prone to unpredictable failures.
>
> **Use this firmware at your own peril.**
>
> More information available 
> [here](https://www.youtube.com/watch?v=EBIahC1P2e0),
> [here](https://www.youtube.com/watch?v=7Utygr71p8s) and 
> [here](https://www.youtube.com/watch?v=q0JEx3uzgSo).

## BLTouch (__REQUIRED__)

The BLTouch bed levelling sensor should be connected to the PROBE (and SERVO) headers,
the precompiled firmware.bin presumes the use of Creality's official metal mounting bracket.

**WARNING:** The Z-STOP header is ignored, as the BLTouch is effectively used as an endstop.

The precompiled firmware.bin was tested using a BLTouch SMART 3.1, if you are getting
inconsistent behavior, try adjusting the magnet inside the BLTouch using the hexnut
located in device's top center. Turning the hexnut 90 degrees clockwise fixed it for me.

## Miscellaneous Notes

Junction deviation is enabled, with a more conservative default value.

Linear Advance is enabled by default and tuned for PLA @ 205C.

S-Curve acceleration is disabled, as it's not fully compatible with Linear Advance.

Maximum bed temperature has been limited to 80C for added safety.

Maximum nozzle temperature has been limited to 250C for added safety.

## Initial Setup

After flashing the precompiled firmware.bin, if desired, you should (re-)calibrate 
your extruder first.

Next do a _bed level corners_, using a ~200gsm (~0.25mm) thick piece of paper.

Finally, attempt a trivial print, lowering the Z-Offset until you get good
bed adhesion, in my particular case I ended up somewhere around -2.15mm.
