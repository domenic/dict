should = require("chai").should()
expect = require("chai").expect

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
