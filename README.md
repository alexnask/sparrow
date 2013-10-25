sparrow
=======

What is sparrow?
----------------

Sparrow is a multiplatform GUI framework written in ooc, for use in ooc.
It can either work on top of the default Win32 widget toolkit or use OpenGL on top of the Win32 API, XLib or Wayland.
The purpose of sparrow is to provide an easy to use, ooc style way of doing things, without an absurd amount of hacks.

Why use sparrow?
----------------

I think a better question is "Why not 'just' bind GTK+, or even a C++ library like Qt and wxWidgets?".
Well, there are actually a few reasons, so allow me to list some below.

- Various problems with the memory model and type system: Basically, we would need a lot of hacks to bind the entirety of one of those libs and make it use the ooc garbage collector and type system without it feeling un-natural.
- Inability to bind C++ libraries: It is mostly impossible to bind C++ libraries in ooc, unless they use a very specific subset of C++. Even in that case, tricks like a C bridge or dynamic loading are needed and those have their issues, like the non-standard C++ name mangling and/or templates, multiple inheritance etc...

Here are some additional reasons to use sparrow, in case you are not convinced

- Sparrow is mostly pure ooc.
- Sparrow uses the ooc SDK.
- Sparrow is easy to use.
- Sparrow is easily extensible.
- Sparrows naturally collide on windows (I'll admit that's how I came up with the name >_>)
- We have pink unicorns.
- Your teeth will shine.

Example
-------

Here are some simple examples of the way I envision Sparrow working

```ooc
use sparrow
import structs/ArrayList
import sparrow/[Window, Button]

main: func(args: ArrayList<String>) -> Int {
	Sparrow init(args)

	win := Window new("Test", 720, 606)
	button := Button new("Close", 200, 50) // Size is optional, will otherwise stretch

	// onClick(f) == callback("click", |evt| f())
	button setPosition(260, 278) . onClick(||
		win close()
	)

	win addChild(button) . show()

	Sparrow loop()
}
```

```ooc
use sparrow
import structs/ArrayList
// There also is sparrow/GUI which imports everything for convenience
import sparrow/[Window, Style, TextEdit, Button, VBox]

main: func(args: ArrayList<String>) -> Int {
	Sparrow init(args)

	// Style is an object describing the esthetics of our widgets
	// You can make your own or use existing ones
	Sparrow style = Style Dark

	win := Window new("Style test", 720, 606)

	// Vertical box
	vBox := VBox new()
	// Space between elemnts will be 20 pixels
	vBox setSpacing(20)
	vBox setPosition(100, 150)

	win addChild(vBox)

	// percent is a property that casts 'this' to Percentage
	// If you pass percentages, then relative sizes are used (orly?!?!?), so the actual absolute sizes are re-calculated each time the parent is resized or we change parents through events
	textEdit := TextEdit new(80 percent, 50 percent)

	textEdit callback("keyTyped", |e|
		match (e as TypedKeyEvent keyCode) {
			case Key Right => "Pressed right key in text edit" println()
			case Key Tab => "Getting back focus because we are arseholes :P" println(); Sparrow focus = textEdit
			case Key Backspace => "New length: #{textEdit value length}" println()
			case => // Flow through!
		}
	)

	// The button will have a fixed size even if the window (and thus VBox) is resized, while the TextEdit will scale up
	button := Button new("Submit!", 200, 50)

	button onClick(||
		textEdit value println()
	)

	vBox addChild(textEdit) . addChild(button)

	win addChild(vBox) . show()

	Sparrow loop()
}
```