from gi import require_version

require_version("Nautilus", "4.1")

from gi.repository import GObject, Gio, Nautilus


class CopyPathAction(GObject.GObject, Nautilus.MenuProvider):
    def _copy(self, _menu, paths):
        Gio.Subprocess.new(["wl-copy", "--", "\n".join(paths)], Gio.SubprocessFlags.NONE)

    def _item(self, name, paths):
        label = "Copy Path" if len(paths) == 1 else "Copy Paths"
        item = Nautilus.MenuItem(name=f"CopyPath::{name}", label=label, icon="edit-copy")
        item.connect("activate", self._copy, paths)
        return item

    def _paths(self, files):
        paths = []
        for file in files:
            location = file.get_location()
            path = location.get_path() if location else None
            if path:
                paths.append(path)
        return paths

    def get_file_items(self, *args):
        paths = self._paths(args[-1])
        return [self._item("files", paths)] if paths else []

    def get_background_items(self, *args):
        paths = self._paths([args[-1]]) if args[-1] else []
        return [self._item("background", paths)] if paths else []
