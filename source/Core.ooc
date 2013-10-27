import structs/ArrayList
import threading/Thread
import Widget, Window, Event, EventHandler, Painter, Style

Sparrow: class {
    _topWidgets := static ArrayList<Widget> new()
    focus: static Widget
    // For now, focus on the OpenGL painter rather than native rendering
    painter := static Painter new()
    style := static Style platformDefault()

    _run? := true

    init: static func(args: ArrayList<String>) {
        // Nothing to do with args here for now
        focus = null
        // Add event thread and paint thread
        threads add(Thread new(||
            EventHandler run()
        ))

        thread add(Thread new(||
            // TODO: Make painter only redraw what is needed
            for(topW in _topWidgets) {
                painter paint(topW)
            }
        ))
    }

    top: static func(w: Widget) {
        _topWidgets add(w)
    }

    untop: static func(w: Widget) {
        _topWidgets remove(w)
    }

    // Those will be joined at end of loop
    threads := static ArrayList<Thread> new()

    loop: static func -> Int {

        // Make a window out of a widget (only way to show it if it is a top level widget)
        windowIze := func(widget: Widget) -> Window {
            (w, h) := widget getSize()
            widget = Window new("Sparrow", widget, w, h)
            widget
        }

        // Pops a top widget and makes a window out of it if needed
        pop := func -> Window {
            widget := _topWidgets first() as Window
            if(!widget instaceOf?(Window)) {
                widget = windowIze(w)
                _topWidgets[0] = widget
            }
            widget
        }

        // We give the focus to one of the top widgets then just look upon them as they fight for the focus
        focus = pop()

        while(_run? && (focus || !_topWidgets empty?())) {
            if(!focus) {
                focus = pop()
            }

            for(thread in threads) {
                thread start()
            }

            for(thread in threads) {
                thread wait()
            }
        }
        0
    }

    // Sends a global signal to all widgets (don't ask me why, just throught it would be nice :P)
    globalSignal: func(name: String, e: Event) {
        for(topW in _topWidgets) {
            topW signalChildren(name, e, false)
        }
    }

    // Forces sparrow to end its loop
    end: func {
        _run? = false
    }
}


// This depends on issue nddrylliog/rock#711
extend Int {
    percent: Float {
        get {
            this / 100
        }
    }
}
