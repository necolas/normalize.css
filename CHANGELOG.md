== HEAD

== 2.1.2 (May 11, 2013)

* Revert root `color` and `background` normalizations.

== 2.1.1 (April 8, 2013)

* Normalize root `color` and `background` to counter the effects of system
  color schemes.

== 2.1.0 (January 21, 2013)

* Normalize `text-transform` for `button` and `select`.
* Normalize `h1` margin when within HTML5 sectioning elements.
* Normalize `hr` element.
* Remove unnecessary `pre` styles.
* Add `main` element to HTML5 display definitions.
* Fix cursor style for disabled button `input`.

== 2.0.1 (August 20, 2012)

* Remove stray IE 6/7 `inline-block` hack from HTML5 display settings.

== 2.0.0 (August 19, 2012)

* Remove legacy browser form normalizations.
* Remove all list normalizations.
* Add `quotes` normalizations.
* Remove all heading normalizations except `h1` font size.
* Form elements automatically inherit `font-family` from ancestor.
* Drop support for IE 6/7, Firefox < 4, and Safari < 5.

== 1.0.1 (August 19, 2012)

* Adjust `small` font size normalization.

== 1.0.0 (August 14, 2012)

(Only the notable changes since public release)

* Add MIT License.
* Hide `audio` elements without controls in iOS 5 (#69).
* Normalize heading margins and font size.
* Move font-family normalization from `body` to `html` (#62).
* Remove scrollbar normalization (#64 #65).
* Remove excess padding from checkbox and radio inputs in IE 7 (#42).
* Add IE9 correction for SVG overflow (#16).
* Add fix for legend not inheriting color in IE 6/7/8/9.
