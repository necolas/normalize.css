# normalize.css

<a href="https://github.com/necolas/normalize.css"><img
  src="https://necolas.github.io/normalize.css/logo.svg" alt="Normalize Logo"
  width="80" height="80" align="right"></a>

> A collection of HTML element and attribute style-normalizations.

[![npm][npm-image]][npm-url] [![license][license-image]][license-url]
[![changelog][changelog-image]][changelog-url]
[![gitter][gitter-image]][gitter-url]


**NPM**

```sh
npm install --save normalize.css
```

**Bower**

```sh
bower install --save normalize-css
```

**CDN**

See https://cdnjs.com/libraries/normalize

**Download**

See http://necolas.github.io/normalize.css/latest/normalize.css


## What does it do?

* Preserves useful defaults, unlike many CSS resets.
* Normalizes styles for a wide range of elements.
* Corrects bugs and common browser inconsistencies.
* Improves usability with subtle improvements.
* Explains what code does using detailed comments.


## Browser support

* Chrome (latest)
* Edge (latest)
* Firefox (latest)
* Firefox ESR
* Internet Explorer 8+
* Opera (latest)
* Safari 6+

*[Normalize.css v1 provides legacy browser support]
(https://github.com/necolas/normalize.css/tree/v1) (IE 6+, Safari 4+),
but is no longer actively developed.*


## Extended details

Additional detail and explanation of the esoteric parts of normalize.css.

#### `pre, code, kbd, samp`

The `font-family: monospace, monospace` hack fixes the inheritance and scaling
of font-size for preformatted text. The duplication of `monospace` is
intentional. [Source](http://en.wikipedia.org/wiki/User:Davidgothberg/Test59).

#### `sub, sup`

Normally, using `sub` or `sup` affects the line-box height of text in all
browsers. [Source](http://gist.github.com/413930).

#### `svg:not(:root)`

Adding `overflow: hidden` fixes IE9's SVG rendering. Earlier versions of IE
don't support SVG, so we can safely use the `:not()` and `:root` selectors that
modern browsers use in the default UA stylesheets to apply this style. [Source]
(http://lists.w3.org/Archives/Public/public-svg-wg/2008JulSep/0339.html).

#### `[type="search"]`

The search input is not fully stylable by default. In Chrome and Safari on
OSX/iOS you can't control `font`, `padding`, `border`, or `background`. In
Chrome and Safari on Windows you can't control `border` properly. It will apply
`border-width` but will only show a border color (which cannot be controlled)
for the outer 1px of that border. Applying `-webkit-appearance: textfield`
addresses these issues without removing the benefits of search inputs (e.g.
showing past searches).


## Contributing

Please read the [contribution guidelines](CONTRIBUTING.md) in order to make the
contribution process easy and effective for everyone involved.


## Acknowledgements

Normalize.css is a project by [Nicolas Gallagher](https://github.com/necolas),
co-created with [Jonathan Neal](https://github.com/jonathantneal).


[changelog-image]: https://img.shields.io/badge/changelog-md-blue.svg?style=flat-square
[changelog-url]: CHANGELOG.md
[license-image]: https://img.shields.io/npm/l/normalize.css.svg?style=flat-square
[license-url]: LICENSE.md
[npm-image]: https://img.shields.io/npm/v/normalize.css.svg?style=flat-square
[npm-url]: https://www.npmjs.com/package/normalize.css
[gitter-image]: https://img.shields.io/badge/chat-gitter-blue.svg?style=flat-square
[gitter-url]: https://gitter.im/necolas/normalize.css
