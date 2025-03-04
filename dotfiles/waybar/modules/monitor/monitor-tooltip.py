import subprocess


class Monitor:
    def __init__(
        self, name: str, make: str, model: str, resolution: str, refresh_rate: str
    ):
        self.name = name
        self.make = make
        self.model = model
        self.resolution = resolution
        self.refresh_rate = refresh_rate

    def show_metadata(self):
        print(f"{self.make} {self.model} - {self.resolution} @ {self.refresh_rate}")

    def show_metadata_full(self):
        print(
            f"{self.name}: {self.make} {self.model} - {self.resolution} @ {self.refresh_rate}"
        )


def notify_system(monitors: list):
    """notifies the system of connected monitors"""

    start_index = len(monitors) - 1
    notification = ""
    for index, monitor in enumerate(monitors):
        reversed_index = start_index - index
        notification = (
            f"Model: {monitor.model} \n{monitor.resolution} @ {monitor.refresh_rate}\n"
        )
        print(notification)
        cmd = [
            "notify-send",
            "-i",
            "display",
            "-a",
            "monitor-tooltip",
            "-r",
            f"54{reversed_index}",
            "-t",
            "5000",
            f"󰹑  {reversed_index}: {monitor.make}",
            f"{notification}",
        ]
        subprocess.run(cmd)
    cmd = [
        "notify-send",
        "-i",
        "display",
        "-a",
        "monitor-tooltip",
        "-r",
        "540",
        "-t",
        "5000",
        f"󰹑  Connected Monitors: {len(monitors)}",
        # f"{notification}",
    ]
    subprocess.run(cmd)


def fetch_connected_monitors():
    """returns the details of connected monitors"""
    cmd = ["wlr-randr"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    output = result.stdout.splitlines()

    monitors = []
    current_monitor = None
    for line in output:
        if "current" in line:
            resolution, refresh_rate = line.split("px, ")
            refresh_rate = refresh_rate.split(" Hz")[0]
            resolution = resolution.strip()
            refresh_rate = refresh_rate.strip()
            # print(f"Res: {resolution}, Rate: {refresh_rate}")
            if current_monitor:
                current_monitor.resolution = resolution
                current_monitor.refresh_rate = refresh_rate
                monitors.append(current_monitor)
        else:
            if "Make:" in line:
                make = line.split("Make: ")[1].strip()
            elif "Model:" in line:
                model = line.split("Model: ")[1].strip()
                name = line.split('"')
                current_monitor = Monitor(name, make, model, "", "")

    return monitors


def main():
    monitor_list = fetch_connected_monitors()
    # for monitor in monitor_list:
    #     monitor.show_metadata()
    notify_system(monitor_list)


if __name__ == "__main__":
    """sends a short summary of connected Monitors to the notification daemon"""
    main()
