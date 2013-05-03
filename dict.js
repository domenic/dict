"use strict";

var hasOwnProperty = Object.prototype.hasOwnProperty;
var MANGLE_STRING = "~";

function mangle(key) {
    return MANGLE_STRING + key;
}

function unmangle(key) {
    return key.substring(MANGLE_STRING.length);
}

function methods(obj, methodHash) {
    for (var methodName in methodHash) {
        Object.defineProperty(obj, methodName, {
            value: methodHash[methodName],
            configurable: true,
            writable: true
        });
    }
}

function assertString(key) {
    if (typeof key !== "string") {
        throw new TypeError("key must be a string.");
    }
}

module.exports = function (initializer) {
    var store = Object.create(null);
    var size = 0;

    var dict = {};
    methods(dict, {
        get: function (key, defaultValue) {
            assertString(key);
            var mangled = mangle(key);
            return mangled in store ? store[mangled] : defaultValue;
        },
        set: function (key, value) {
            assertString(key);

            var mangled = mangle(key);
            if (!(mangled in store)) {
                ++size;
            }

            return store[mangled] = value;
        },
        has: function (key) {
            assertString(key);
            return mangle(key) in store;
        },
        delete: function (key) {
            assertString(key);

            var mangled = mangle(key);
            if (mangled in store) {
                --size;
                delete store[mangled];
                return true;
            }

            return false;
        },
        clear: function () {
            store = Object.create(null);
            size = 0;
        },
        forEach: function (callback, thisArg) {
            if (typeof callback !== "function") {
                throw new TypeError("`callback` must be a function");
            }

            for (var mangledKey in store) {
                if (hasOwnProperty.call(store, mangledKey)) {
                    var key = unmangle(mangledKey);
                    var value = store[mangledKey];

                    callback.call(thisArg, value, key, dict);
                }
            }
        }
    });

    Object.defineProperty(dict, "size", {
        get: function () {
            return size;
        },
        configurable: true
    });

    if (typeof initializer === "object" && initializer !== null) {
        Object.keys(initializer).forEach(function (key) {
            dict.set(key, initializer[key]);
        });
    }

    return dict;
};
