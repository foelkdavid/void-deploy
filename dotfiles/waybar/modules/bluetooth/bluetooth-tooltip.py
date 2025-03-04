#!/bin/python3

import subprocess

icon_lookup = {
    "input-gaming": "󰊴 ",
    "audio-headset": "󰋎 ",
    "phone": " ",
    "audio-card": "󰓃 ",
}


class BtDevice:
    def __init__(self, name: str, mac: str, icon: str):
        self.name = name
        self.mac = mac
        self.icon = icon_lookup.get(icon, " ")

    def show_metadata(self):
        print(f"{self.icon} {self.name}")

    def show_metadata_full(self):
        print(f"{self.icon} {self.name}\t({self.mac})")


def notify_system(devices: list):
    """notifies the system of connected devices"""
    notification = ""
    for device in devices:
        notification = notification + f"{device.icon}  {device.name}\n"
    cmd = [
        "notify-send",
        "-i",
        "bluetooth-symbolic",
        "-a",
        "bluetooth-tooltip",
        "-r",
        "11",
        "Connected Devices",
        f"{notification}",
    ]
    subprocess.run(cmd)


def fetch_connected_bt_macs():
    """returns the mac-addresses of connected bluetooth devices"""
    cmd = ["bluetoothctl", "devices", "Connected"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    output = result.stdout.splitlines()
    device_macs = []
    for device in output:
        device_macs.append(device.split()[1])
    return device_macs


def get_device_metadata(mac: str):
    """fetches bt-device-metadata from mac address using bluetoothctl and returns a BTDevice"""

    # fetch data
    cmd = ["bluetoothctl", "info", mac]
    result = subprocess.run(cmd, capture_output=True, text=True)
    metadata_lines = result.stdout.splitlines()
    # print(metadata_lines[0].split(":", 1))

    # fill dict
    metadata_dict = {}
    for line in metadata_lines:
        try:
            key, value = line.split(":", 1)
            key = key.strip()
            value = value.strip()
            metadata_dict[key] = value
        except Exception:
            continue

    # return desired key/value pairs
    name = str(metadata_dict.get("Name"))
    icon = str(metadata_dict.get("Icon"))
    # TODO: Optionally add Battery level

    return BtDevice(name, mac, icon)


def fill_device_list(mac_list: list):
    """takes a list of mac addresses and checks device-metadata using bluetoothctl"""
    device_list = []
    for mac in mac_list:
        device_list.append(get_device_metadata(mac))
    return device_list


def main():
    device_list = fill_device_list(fetch_connected_bt_macs())
    for device in device_list:
        device.show_metadata()
    notify_system(device_list)


if __name__ == "__main__":
    """sends a short summary of connected Bluetooth Devices to the notification daemon"""
    main()
