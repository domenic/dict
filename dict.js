"use strict";

function mangle(key) {
    return "~" + key;
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

            store[mangled] = value;
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
            }

            delete store[mangle(key)];
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
