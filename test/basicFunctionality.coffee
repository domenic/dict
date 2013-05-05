"use strict"

require("chai").use(require("sinon-chai"))
should = require("chai").should()
expect = require("chai").expect
sinon = require("sinon")

dict = require("../dict")

describe "Dict under normal usage", ->
    d = null

    beforeEach ->
        d = dict()

    it "should say it has a key once it is set", ->
        d.set("key", "value")
        d.has("key").should.equal(true)

    it "should be able to get a key once it is set", ->
        obj = {}
        d.set("key", obj)
        d.get("key").should.equal(obj)

    it "should return undefined for unset keys", ->
        expect(d.get("key")).to.equal(undefined)

    it "should use the supplied fallback value when getting unset keys", ->
        obj = {}
        d.get("key", obj).should.equal(obj)

    it "should know how many keys are set", ->
        d.size.should.equal(0)
        d.set("k1", "v1")
        d.size.should.equal(1)
        d.set("k2", "v2")
        d.size.should.equal(2)
        d.set("k1", "v3")
        d.size.should.equal(2)
        d.delete("k1")
        d.size.should.equal(1)
        d.delete("bogus")
        d.size.should.equal(1)
        d.delete("k2")
        d.size.should.equal(0)

    it "should return `true` when deleting keys that are present; `false` otherwise", ->
        d.delete("k").should.be.false
        d.set("k", "v")
        d.delete("k").should.be.true
        d.delete("k").should.be.false

    it "should return the value set", ->
        d.set("k", "v").should.equal("v")

    it "should allow clearing all keys", ->
        d.set("k1", "v1")
        d.set("k2", "v2")

        d.clear()

        expect(d.get("k1")).to.equal(undefined)
        d.has("k1").should.be.false
        expect(d.get("k2")).to.equal(undefined)
        d.has("k2").should.be.false
        d.size.should.equal(0)

    describe "forEach", ->
        it "should execute the callback function with args `(value, key, dict)`", ->
          d.set("key1", "value1")
          d.set("key2", "value2")
          d.set("key3", "value3")

          spy = sinon.spy()
          d.forEach(spy)

          spy.should.have.been.calledThrice
          spy.getCall(0).should.have.been.calledWithExactly("value1", "key1", d)
          spy.getCall(1).should.have.been.calledWithExactly("value2", "key2", d)
          spy.getCall(2).should.have.been.calledWithExactly("value3", "key3", d)

        it "should use the `thisArg` to set the `this` inside the callback", ->
            thisArg = { "i am": "this!" }
            d.set("key", "value")

            spy = sinon.spy()
            d.forEach(spy, thisArg)

            spy.should.have.been.calledOnce
            spy.getCall(0).should.have.been.calledWithExactly("value", "key", d)
            spy.getCall(0).should.have.been.calledOn(thisArg)

    describe "when values are undefined or falsy", ->
        beforeEach ->
            d.set("key1", undefined)
            d.set("key2", 0)
            d.set("key3", false)

        it "should still say it has those keys", ->
            d.has("key1").should.equal(true)
            d.has("key2").should.equal(true)
            d.has("key3").should.equal(true)

        it "should still be able to retrieve those values", ->
            expect(d.get("key1")).to.equal(undefined)
            d.get("key2").should.equal(0)
            d.get("key3").should.equal(false)

        it "should not use the supplied fallback value when getting those keys", ->
            expect(d.get("key1", "fallback")).to.equal(undefined)
            d.get("key2", "fallback").should.equal(0)
            d.get("key3", "fallback").should.equal(false)

    describe "when a key is deleted", ->
        beforeEach ->
            d.set("key", "value")
            d.delete("key")

        it "should no longer have that key", ->
            d.has("key").should.equal(false)

        it "should return undefined for that key", ->
            expect(d.get("key")).to.equal(undefined)

describe "Dict with constructor argument", ->
    it "should not react to non-object arguments", ->
        (-> dict(null)).should.not.throw()
        (-> dict(true)).should.not.throw()

    it "should get an element from the constructor", ->
        obj = {}
        d = dict({ key: obj })
        d.has("key").should.equal(true)
        d.get("key").should.equal(obj)

    it "should get multiple elements from the constructor", ->
        obj = {}
        d = dict({ key: obj, key2: 42 })
        d.has("key").should.equal(true)
        d.get("key").should.equal(obj)
        d.has("key2").should.equal(true)
        d.get("key2").should.equal(42)

    it "should not get elements from the constructor argument's prototype", ->
        d = dict({ })
        d.has("hasOwnProperty").should.equal(false)
        d.has("toString").should.equal(false)
