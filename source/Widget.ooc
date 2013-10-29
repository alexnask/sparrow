import structs/[List, MultiMap]
import Core, Event, Painter, Style

Widget: abstract class {
    _callbacks := MultiMap<String, Func(Event)> new()
    parent: This

    ctxMenu: This

    width, height: Int
    percentageWidth, percentageHeight: Float
    absoluteSize? := true

    x, y: Int
    percentageX, percentageY: Float
    absolutePosition? := true

    // The widget's personal style!
    style: Style = null

    shown? := false
    enabled? := true

    init: func {
    	// A widget is toped by default but is untoped when it aquires a parent or is closed
        Sparrow top(this)
    }

    getSize: func -> (Int, Int) {
        if(absoluteSize?) return (width, height)
        else if(parent) {
            (pWidth, pHeight) := parent getSize()
            return (pWidth * percentageWidth, pHeight * percentageHeight)
        }
        (-1, -1)   
    }

    getPosition: func -> (Int, Int) {
        if(absolutePosition?) return(x, y)
        else if(parent) {
            (pWidth, pHeight) := parent getSize()
            return (pWidth * percentageX, pHeight * percentageY)
        }
        (-1, -1)
    }

    setPosition: func~abs (=x, =y) {
        absolutePosition? = true
        ev := RepositionEvent new(x, y)
        signal("repositioned", ev)
        // Children don't need to know about this
    }

    setPosition: func~rel (=percentageX, =percentageY) {
        absolutePosition? = false

        (x, y) := getPosition()
        ev := RepositionEvent new(x, y)
        signal("repositioned", ev)
    }

    setSize: func~abs (=width, =height) {
        absoluteSize? = true

        ev := ResizeEvent new(width, height)
        signal("resized", ev)
        signalChildren("resized", ev)
    }

    setSize: func~rel (=percentageWidth, =percentageHeight) {
        absoluteSize? = false

        (w, h) := getSize()
        ev := ResizeEvent new(w, h)
        signal("resized", ev)
        signalChildren("resized", ev)
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

    // Clear onRightClick
    onRightClick: func(action: Func) {
        callback("rightClicked", |e|
            action
        )
    }

    // onRightClick with coordinates
    onRightClick: func(action: Func(Int, Int)) {
        callback("rightClicked", |e|
            action(e as ClickEvent x, e as ClickEvent y)
        )
    }

    onKeyPress: func(action: Func(KeyCode)) {
        callback("keyPressed", |e|
            action(e as KeyPressEvent code)
        )
    }


    // Should I start the callbacks in different threads?
    // It might be overkill since signals are genrally sent inside the event loop
    // If you need to do a data heavy operation, start a thread yourself
    signal: func(name: String, event: Event) -> Bool {
        captured? := false
        cbs := _callbacks[name]
        if(cbs && cbs instanceOf?(List)) for(cb in cbs) {
            cb(event)
            captured? = true
        } else if(cbs) {
            cbs(event)
            captured? = true
        }

        captured?
    }

    // This should be implemented but implementations should call super()
    addChild: func(child: This) {
        child parent = this
        Sparrow untop(child)

        ev := WidgetEvent new(child)
        signal("childAdded", ev)

        ev = WidgetEvent new(this)
        child signal("gotParent", ev)
    }

    addContextMenu: func(=ctxMenu) {
        ev := WidgetEvent new(ctxMenu)
        signal("menuAdded", ev)

        onRightClick(|posX, posY|
            ctxMenu setPosition(posX, posY)
            ctxMenu show()
            ctxMenu getFocus()
        )

        ctxMenu callback("unfocused", |e|
            ctxMenu hide()
        )
    }

    getChildren: abstract func -> List<This>

    getNextChild: abstract func(child: This) -> This

    show: func {
    	shown? = true
    }

    hide: func {
    	shown? = false
    }

    enable: func {
        enabled? = true
    }

    disable: func {
        enabled? = false
    }

    close: func {
        Sparrow untop(this)
        if(sparrow focus == this) Sparrow focus = parent

        ev := EmptyEvent new() as Event
        signal("closed", ev)
        if(parent) {
            // Should I actually send both those signals?
            ev = WidgetEvent new(parent) as Event
            signal("unfocused", ev)
        }
    }

    getFocus: func {
        ev := WidgetEvent new(Sparrow focus)

        Sparrow focus = this
        signal("focused", ev)
    }

    // Sends a signal to all children.
    // Setting tagged? to true will cause the signal name to be prepended with 'parent_'
    signalChildren(name: String, e: Event, tagged? := true) {
        if(tagged?) name = "parent_#{name}"

        getChildren() each(|child|
            child signal(name, e)
        )
    }

    paint: abstract func(painter: Painter)
}
