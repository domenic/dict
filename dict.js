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

module.exports = function () {
	var store = Object.create(null);

	var dict = {};
	methods(dict, {
		get: function (key, defaultValue) {
			assertString(key);
			var mangled = mangle(key);
			return mangled in store ? store[mangled] : defaultValue;
		},
		set: function (key, value) {
			assertString(key);
			store[mangle(key)] = value;
		},
		has: function (key) {
			assertString(key);
			return mangle(key) in store;
		},
		delete: function (key) {
			assertString(key);
			delete store[mangle(key)];
		}
	});

	var init = arguments[0];
	if (typeof init === "object") {
		for (var key in init) {
			if (Object.hasOwnProperty.call(init, key)) {
				dict.set(key, init[key]);
			}
		}
	}

	return dict;
};
