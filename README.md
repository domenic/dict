# An Easy But Safe String-Keyed Store

Don't stuff things into objects. Use a Dict instead.

## The Problem

You're probably used to stuffing things into objects:

```js
var hash = {};

hash["foo"] = "bar";

console.log("foo" in hash ? hash["foo"] : "not there"); // "bar"
```

However this doesn't always work, because your naïve hashes inherit from
[`Object.prototype`][1]:

```js
var hash = {};

console.log("hasOwnProperty" in hash); // true!
```

Even worse, the magic `__proto__` property can really [ruin your day][2]:

```js
var hash = {};
var anotherObject = { foo: "bar" };

hash["__proto__"] = anotherObject;

console.log("foo" in hash);       // true!!
console.log("__proto__" in hash); // false!!!
```

Usually you're smart enough to avoid silly key names like `"hasOwnProperty"`, `"__proto__"`, and all the rest. But
sometimes you want to store user input in your hashes. Uh-oh…

## Dict Is the Solution

Just do an `npm install dict --save` and you're ready to use this nice-looking API:

```js
var dict = require("dict");

var d = dict({
    IV: "A New Hope",
    V: "The Empire Strikes Back",
    VI: "Return of the Jedi"
});

d.has("IV");                      // true
d.get("V");                       // "The Empire Strikes Back"
d.size;                           // 3

d.has("I");                       // false
d.set("I", "The Phantom Menace"); // "The Phantom Menace"
d.get("I");                       // "The Phantom Menace"
d.delete("I");                    // true
d.get("I");                       // undefined
d.get("I", "Jar-Jar's Fun Time"); // "Jar-Jar's Fun Time"

d.forEach(function (value, key) {
   console.log("Star Wars Episode " + key + ": " + value);
});

d.clear();
d.size;                           // 0
```

And of course, Dict prides itself in being bulletproof against all that nastiness we talked about earlier:

```javascript
var d = dict();

d.set("foo", "bar");
console.log(d.get("foo", "not there")); // "bar"

console.log(d.has("hasOwnProperty"));   // false

var anotherObject = { baz: "qux" };
d.set("__proto__", anotherObject);
console.log(d.has("baz"));              // false
console.log(d.has("__proto__"));        // true
```

## Featuring

* A lightweight [ES6-inspired][3] API:
  - `get`, `set`, `has` and `delete` basic operations.
  - A `size` property and `forEach` method for introspection.
  - A `clear` method for clearing out all keys and values.
* `get` accepts a second argument as a fallback for if the key isn't present (like [Mozilla's `WeakMap`][4]).
* `set` returns the value set, just like assignment to an object would.
* Doesn't let you get away with being dumb: if you pass a non-string as a key, you're going to get a `TypeError`.

## See Also

* [rauschma/strmap][7] for something a bit more full-featured (albeit exposing its internals everywhere, if you care
  about that).
* [dherman/dictjs][8] if you live in an ES6 world.
* [es-lab's StringMap.js][9] if you can deal with the lack of npm support.
* [es6-shim][10]'s `Map` if you want more than just strings for your keys.
* `Object.create(null)` if you don't have to deal with V8 or JavaScriptCore, for which
  `"__proto__" in Object.create(null)` is still true.


[1]:  https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/prototype
[2]:  http://www.google.com/support/forum/p/Google+Docs/thread?tid=0cd4a00bd4aef9e4
[3]:  http://people.mozilla.org/~jorendorff/es6-draft.html#sec-15.14.4
[4]:  https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/WeakMap
[5]:  http://visionmedia.github.com/mocha/
[6]:  http://chaijs.com/
[7]:  https://github.com/rauschma/strmap
[8]:  https://github.com/dherman/dictjs
[9]:  http://code.google.com/p/es-lab/source/browse/trunk/src/ses/StringMap.js
[10]: https://github.com/paulmillr/es6-shim
