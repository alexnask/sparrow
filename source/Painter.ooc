version(windows) {
    import native/win32/WinApiOpenGLPainter
} else version(X11 || (!X11 && !wayland)) {
    import native/X11/XLibOpenGLPainter
} else {
    import native/wayland/WaylandOpenGLPainter
}

Painter: class {
    new: static func -> This {
        version(windows) {
            return WinApiOpenGLPainter new()
        } else version(X11 || (!X11 && !wayland)) {
            return XLibOpenGLPainter new()
        } else version(wayland) {
            return WaylandOpenGLPainter new()
        }
        raise("Usupported platform."); null
    }

   	// Add functions to paint lines, circles, gradients and all kind of stuff
}