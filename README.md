# normalize.css v2.0.1

Normalize.css is a customisable CSS file that makes browsers render all
elements more consistently and in line with modern standards. We researched the
differences between default browser styles in order to precisely target only
the styles that need normalizing.

[Check out the demo](http://necolas.github.com/normalize.css/2.0.1/test.html)

## What does it do?

* Preserves useful defaults, unlike many CSS resets.
* Normalizes styles for a wide range of elements.
* Corrects bugs and common browser inconsistencies.
* Improves usability with subtle improvements.
* Explains what code does using detailed comments.

## How is it different from "reset" stylesheets?

1. **It preserves useful defaults.**
Resets impose a homogenous visual style by flattening the default styles for almost all elements.
In contrast, normalize.css retains and harmonizes many useful default browser styles,
so they don’t have to be redefined to work well typographically,
allowing your stylesheet to contain only the changes needed to implement a specific design.

2. **It corrects common bugs.**
Normalize.css fixes common desktop and mobile browser bugs that are out of scope for resets.
This includes display settings for HTML5 elements, correcting font-size for preformatted text,
SVG overflow in IE9, and many form-related bugs across browsers and operating systems.
 
3. **It is modular and doesn’t clutter debugging tools.**
Normalize.css is broken down into relatively independent sections,
making it easy to remove sections (e.g., the form normalizations) if they won't be needed by a specific project.
This modular philosophy also motivates the use of targeted selectors,
as opposed to multiple selectors, whenever possible and appropriate.
This avoids the long inheritance chains that are displayed in browser CSS debugging tools when resets are used.

## How to use it

Normalize.css is intended to be used as an alternative to CSS resets.

It's suggested that you read the `normalize.css` file and consider customising
it to meet your needs. Alternatively, include the file in your project and
override the defaults later in your CSS.

## Browser support

* Google Chrome
* Mozilla Firefox 4+
* Apple Safari 5+
* Opera 12+
* Internet Explorer 8+

## Contribute

Please read my [issue
guidelines](https://github.com/necolas/issue-guidelines).

## Acknowledgements

Normalize.css is a project by [Nicolas Gallagher](http://github.com/necolas)
and [Jonathan Neal](http://github.com/jonathantneal).
