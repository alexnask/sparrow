import Core

version(windows) {
    import native/win32/WinApiEventHandler
} else version(X11 || (!X11 && !wayland)) {
    import native/X11/XLibEventHandler
} else {
    import native/wayland/WaylandEventHandler
}

EventHandler: class {
    run: static func {
        version(windows) {
            WinApiEventHandler run()
        } else version(X11 || (!X11 && !wayland)) {
            XLibEventHandler run()
        } else version(wayland) {
            WayLandHandler run()
        } else {
            raise("Unsupported platform.")
        }
    }
}
