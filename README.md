An easy but safe string-keyed store
===================================

Don't stuff things into objects. Use a `dict` instead.

The problem
-----------

You're probably used to stuffing things into objects:

```javascript
var hash = {};

hash["foo"] = "bar";

console.log("foo" in hash ? hash["foo"] : "not there"); // "bar"
```

However this doesn't always work, because your naïve hashes inherit from
[`Object.prototype`][1]:

```javascript
var hash = {};

console.log("hasOwnProperty" in hash); // true!
```

Even worse, the magic `__proto__` property can really [ruin your day][2]:

```javascript
var hash = {};
var anotherObject = { foo: "bar" };

hash["__proto__"] = anotherObject;

console.log("foo" in hash);       // true!!
console.log("__proto__" in hash); // false!!!
```

Usually you're smart enough to avoid silly key names like `"hasOwnProperty"`, `"__proto__"`, and all the rest. But sometimes you want to
store user input in your hashes. Uh-oh…

dict is the solution
----------------------

Just do an `npm install dict` and you're good to go:

```javascript
var dict = require("dict");

var d = dict();

d.set("foo", "bar");
console.log(d.get("foo", "not there")); // "bar"

console.log(d.has("hasOwnProperty")); // false :)

var anotherObject = { baz: "qux" };
d.set("__proto__", anotherObject);
console.log(d.has("baz"));       // false :)
console.log(d.has("__proto__")); // true :)
```

Featuring
---------

* A lightweight [ES6-inspired][3] API: `get`, `set`, `has`, `delete`.
* `get` accepts a second argument as a fallback for if the key isn't present (like [Mozilla's `WeakMap`][4]).
* Doesn't let you get away with being dumb: if you pass a non-string as a key, you're going to get a `TypeError`.
* A full suite of unit tests using [mocha][5] and [chai][6]: `npm test` awaits you.

See Also
--------

* [rauschma/strmap][7] for something a bit more full-featured (albeit exposing its internals everywhere, if you care about that).
* [dherman/dictjs][8] if you live in an ES6 world.
* [es-lab's StringMap.js][9] if you can deal with the lack of npm support.
* [es6-shim][10]'s `Map` if you want more than just strings for your keys.


[1]:  https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/prototype
[2]:  http://www.google.com/support/forum/p/Google+Docs/thread?tid=0cd4a00bd4aef9e4
[3]:  http://wiki.ecmascript.org/doku.php?id=harmony:simple_maps_and_sets
[4]:  https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/WeakMap
[5]:  http://visionmedia.github.com/mocha/
[6]:  http://chaijs.com/
[7]:  https://github.com/rauschma/strmap
[8]:  https://github.com/dherman/dictjs
[9]:  http://code.google.com/p/es-lab/source/browse/trunk/src/ses/StringMap.js
[10]: https://github.com/paulmillr/es6-shim
