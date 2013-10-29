import ../../[Event, Core]

WinApiEventHandler: class {
    run: static func {
        // Outline

        // Key Presses
        // Tab => if(!focus signal("keyPressed", KeyPressEvent new(KeyCode tab))) -> if(focus parent) focus = focus parent nextChild(focus)
        // Everything else => focus signal("keyPressed", KeyPressEvent(...))

        // Clicks
        // Should we let the right click menus be handled from callbacks or should we add a rightClickMenu on Widget?
        // Left Click -> Find the widget we clicked -> focus = widget; focus signal("clicked", ClickEvent new(x, y))
        // What happens with scrollbars MANG?
        // Right click -> focus signal("clicked", RightClickEvent new(x, y))
    }
}
