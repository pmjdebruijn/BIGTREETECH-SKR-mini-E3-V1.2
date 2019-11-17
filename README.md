# BigTreeTech SKR-mini-E3 V1.2

> **WARNING:** 
> The firmware.bin supplied in this repository requires the use of the extended
> 512KB of flash seemingly available on most of these boards. The second
> 256KB half is that flash is officially out of spec, and therefore maybe
> more prone to unexpected failures. *Use this firmware at your own peril*.
>
> More information available 
> [here](https://www.youtube.com/watch?v=EBIahC1P2e0),
> [here](https://www.youtube.com/watch?v=7Utygr71p8s) and 
> [here](https://www.youtube.com/watch?v=q0JEx3uzgSo).

## BLTouch               

The supplied firmware.bin was tested using a BLTouch SMART 3.1, if you are getting
inconsistent behavior, try adjusting the magnet inside the BLTouch using the hexnut
located in device's top center. Turning the hexnut 90 degrees clockwise fixed it for me.

## Notes

The BLTouch bed levelling sensor works when connected to the PROBE (and SERVO) headers,
the supplied firmware.bin presumes the use of Creality's official metal mounting bracket.
Your Z endstop microswitch should remain connected to the Z-STOP header as per usual.

Junction deviration is enabled.
S-Curve acceleration is enabled.
Linear Advance is available but disabled by default.

Maximum bed temperature has been limited to 70C to prevent the bed from demagnetizing.
Maximum nozzle temperature has been limited to 250C for added safety.

## Setup

After flashing the supplied firmware.bin, you should first calibrate your extruder,
in my particular case I ended up somewhere around 96 steps/mm.

Next do a _bed level corners_, using a ~200gsm (~0.25mm) thick piece of paper.

Finally, attempt a trivial print, lowering the Z-Offset until you get good bed adhesion,
in my particular case I ended up somewhere around -2.25mm.
