import structs/[List, MultiMap]
import Core, Event, Painter, Style

Widget: abstract class {
    _callbacks := MultiMap<String, Func(Event)> new()
    parent: This

    // The widget's personal style!
    style: Style = null

    shown? := false
    enabled? := true

    init: func {
    	// A widget is toped by default but is untoped when it aquires a parent or is closed
        Sparrow top(this)
    }

    callback: func(name: String, action: Func(Event)) {
        // The context of the Func is on the stack, so we need to keep it to call it in the future
        closure: Closure* = gc_malloc(Closure size)
        memcpy(closure, action&, Closure size)

        _callbacks add(name, closure@ as Func(Event))
    }

    // Convenience callbacks

    // Clear onClick
    onClick: func(action: Func) {
        callback("clicked", |e|
            action()
        )
    }

    // onClick with coordinates
    onClick: func(action: Func(Int, Int)) {
        callback("clicked", |e|
            action(e as ClickEvent x, e as ClickEvent y)
        )
    }

    onKeyPress: func(action: Func(KeyCode)) {
        callback("keyPressed", |e|
            action(e as KeyPressEvent code)
        )
    }


    signal: func(name: String, event: Event) {
        cbs := _callbacks[name]
        if(cbs && cbs instanceOf?(List)) for(cb in cbs) {
            cb(event)
        } else if(cbs) {
            cbs(event)
        }
    }

    // This should be implemented but implementations should call super()
    addChild: func(child: Widget) {
        child parent = this
        Sparrow untop(child)

        ev := WidgetEvent new(child)
        signal("childAdded", ev)
    }

    show: func {
    	shown? = true
    }

    hide: func {
    	shown? = false
    }

    close: func {
        Sparrow untop(this)
        if(sparrow focus == this) Sparrow focus = parent

        ev := EmptyEvent new()
        signal("closed", ev)
    }

    paint: abstract func(painter: Painter)
}
