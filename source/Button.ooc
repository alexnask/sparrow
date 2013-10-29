import structs/List
import Core, Widget, Event, Painter

// TODO: onMousePressed, onMouseReleased, behaviour and graphic changes due to them
Button: class extends Widget {
	action: Func

	init: func(=action, keyBoardActivated?: Bool) {
		onClick(action)
		if(keyBoardActivated?) onKeyPress(|code|
			if(code == KeyCode enter) action()
		)
	}

	// Do nothing - can't add children to buttons... perhaps raise a runtime error?
	addChild: func(child: Widget)
	getChildren: func -> List<Widget> { null }
	getNextChild: func(child: Widget) -> Widget { null }

	paint: func(painter: Painter) {

	}
}
