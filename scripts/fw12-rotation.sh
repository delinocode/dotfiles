#!/usr/bin/env bash
set -euo pipefail

# Framework Laptop 12 auto-rotation setup for Pop!_OS COSMIC.

if [[ "${EUID}" -eq 0 ]]; then
  echo "Run this script as a normal user, not with sudo." >&2
  exit 1
fi

sudo apt update
sudo apt install -y iio-sensor-proxy wlr-randr

sudo mkdir -p /etc/udev/hwdb.d
sudo tee /etc/udev/hwdb.d/61-sensor-local.hwdb >/dev/null <<'EOF'
# Framework Laptop 12
sensor:modalias:platform:cros-ec-accel:dmi:*svnFramework:pnLaptop12*
 ACCEL_MOUNT_MATRIX=-1, 0, 0; 0, -1, 0; 0, 0, -1
EOF

sudo systemd-hwdb update
sudo udevadm trigger --subsystem-match=iio --action=add
sudo systemctl restart iio-sensor-proxy.service || true

repo_dir="${HOME}/cosmic-applet-rotation"
if [[ ! -d "${repo_dir}/.git" ]]; then
  git clone https://github.com/armaaar/cosmic-applet-rotation.git "${repo_dir}"
fi

cd "${repo_dir}"
if ! command -v cargo >/dev/null 2>&1; then
  echo "cargo is required. Install Rust with rustup, then rerun this script." >&2
  exit 1
fi

if ! command -v just >/dev/null 2>&1; then
  echo "just is required. Install it with: sudo apt install just" >&2
  exit 1
fi

just build-release
sudo just install

echo
echo "Setup complete."
echo "If the Rotation applet is already in the COSMIC panel, remove and add it again."
echo "Test the sensor with: monitor-sensor --accel"
