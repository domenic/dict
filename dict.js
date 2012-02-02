"use strict";

function mangle(key) {
	return "~" + key;
}

function assertString(key) {
	if (typeof key !== "string") {
		throw new TypeError("key must be a string.");
	}
}

module.exports = function () {
	var store = Object.create(null);

	return {
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
	};
};
