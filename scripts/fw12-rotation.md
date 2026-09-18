# Framework 12 Rotation

This setup enables automatic screen rotation on a Framework Laptop 12 running Pop!_OS COSMIC.

## What it installs

- `iio-sensor-proxy` for accelerometer orientation events.
- `wlr-randr`, which the rotation applet uses to detect and rotate the internal display.
- The Framework 12 accelerometer mount-matrix hwdb rule.
- `cosmic-applet-rotation` from GitHub, built and installed locally.

## Run the script

From the repository root:

```bash
chmod +x fw12-rotation.sh
./fw12-rotation.sh
```

Run it as a normal user. The script calls `sudo` only for system-level operations.

## Add the applet

After installation, add the Rotation applet to the COSMIC panel. If it was already present during installation, remove it and add it again so it detects `wlr-randr`.

## Test the sensor

```bash
monitor-sensor --accel
```

Expected output includes orientation changes such as:

```text
Accelerometer orientation changed: normal
Accelerometer orientation changed: right-up
Accelerometer orientation changed: left-up
```

## Troubleshooting

Check that the internal display is visible to `wlr-randr`:

```bash
wlr-randr
```

The output should contain an enabled internal display such as `eDP-1`.

Check the kernel and IIO devices:

```bash
uname -r
ls /sys/bus/iio/devices/
sudo dmesg | grep -iE "cros_ec|iio|sensorhub"
```

Check the DRM connector:

```bash
for f in /sys/class/drm/card*-*/status; do
  echo "$f: $(cat "$f" 2>/dev/null)"
done
```

The internal connector should report `connected`.

## Files installed

The script creates:

```text
/etc/udev/hwdb.d/61-sensor-local.hwdb
```

The applet is installed at:

```text
/usr/bin/cosmic-applet-rotation
```
