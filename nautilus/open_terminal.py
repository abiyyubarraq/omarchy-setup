from gi import require_version

require_version("Nautilus", "4.1")

from gi.repository import GObject, Gio, Nautilus


class OpenTerminalAction(GObject.GObject, Nautilus.MenuProvider):
    def _open(self, _menu, path):
        Gio.Subprocess.new(["xdg-terminal-exec", f"--dir={path}"], Gio.SubprocessFlags.NONE)

    def _item(self, name, path):
        item = Nautilus.MenuItem(
            name=f"OpenTerminal::{name}",
            label="Open in Terminal",
            icon="utilities-terminal",
        )
        item.connect("activate", self._open, path)
        return item

    def get_background_items(self, *args):
        folder = args[-1]
        location = folder.get_location() if folder else None
        path = location.get_path() if location else None
        return [self._item("background", path)] if path else []

    def get_file_items(self, *args):
        files = args[-1]
        if len(files) != 1 or not files[0].is_directory():
            return []
        location = files[0].get_location()
        path = location.get_path() if location else None
        return [self._item("folder", path)] if path else []
