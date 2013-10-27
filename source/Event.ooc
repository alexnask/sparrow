import Widget

Event: abstract class {
	init: func
}

EmptyEvent: class extends Event {
	init: super func
}

WidgetEvent: class extends Event {
	widget: Widget

	init: func(=widget)
}

ResizedEvent: class extends Event {
	width, height: Int

	init: func(=width, =height)
}

RepositionedEvent: class extends Event {
	x, y: Int

	init: func(=x, =y)
}

ClickEvent: class extends Event {
	x, y: Int

	init: func(=x, =y)
}

RightClickEvent: class extends ClickEvent {
	init: func(=x, =y)
}

KeyPressEvent: class extends Event {
	code: KeyCode

	init: func(=code)
}

// Here is a list of keycodes
// Shamelessly taken from SDL
KeyCode: enum {
	// Fill it up!
	unknown,
	backspace = 8,
	tab,
	ret = 13,
	escape = 27,
	space = 32,
	bang,
	doubleQuote,
	hash,
	dollar,
	percent,
	ampersand,
	quote,
	leftParen,
	rightParen,
	asterisk,
	plus,
	comma,
	minus,
	period,
	slash,
	zero,
	one,
	two,
	three,
	four,
	five,
	six,
	seven,
	eight,
	nine,
	colon,
	semicolon,
	less,
	equals,
	greater,
	question,
	alt,
	leftBracket,
	backslash,
	rightBracket,
	caret,
	underscore,
	backquote,
	a,
	b,
	c,
	d,
	e,
	f,
	g,
	h,
	i,
	j,
	k,
	l,
	m,
	n,
	o,
	p,
	q,
	r,
	s,
	t,
	u,
	v,
	w,
	x,
	y,
	z,
	delete = 177
	// TODO: add more
		

	aciiChar?: func -> Bool {
		this as Int >= 0 && this as Int <= 127
	}

	digit?: func -> Bool {
		this as Char digit?()
	}

	alpha?: func -> Bool {
		this as Char alpha?()
	}
}
