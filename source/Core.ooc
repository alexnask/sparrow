import structs/ArrayList
import threading/Thread
import Widget, EventHandler, Painter, Style

Sparrow: class {
    _topWidgets := static ArrayList<Widget> new()
    focus: static Widget
    // For now, focus on the OpenGL painter rather than native rendering
    painter := static Painter new()
    style := static Style platformDefault()

    init: static func(args: ArrayList<String>) {
        // Nothing to do here for now
        focus = null
        // Add event thread and paint thread
        threads add(Thread new(||
            EventHandler run()
        ))

        thread add(Thread new(||
            // TODO: Make painter only redraw what is needed
            for(topW in _topWidgets) {
                topW paint(painter)
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
        // We give the focus to one of the top widgets then just look upon them as they fight for the focus
        focus = _topWidgets first()

        while(focus) {
            for(thread in threads) {
                thread start()
            }

            for(thread in threads) {
                thread wait()
            }
        }
        0
    }
}
