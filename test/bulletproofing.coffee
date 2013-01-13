"use strict"

should = require("chai").should()
expect = require("chai").expect

dict = require("../dict")

describe "Dict under unconventional, malicious, or dumb usage", ->
    d = null

    beforeEach ->
        d = dict()

    it 'should not have a key named "hasOwnProperty" initially', ->
        d.has("hasOwnProperty").should.equal(false)

    it 'should be able to handle a "hasOwnProperty" key being set', ->
        obj = {}
        d.set("hasOwnProperty", obj)

        d.has("hasOwnProperty").should.equal(true)
        d.get("hasOwnProperty").should.equal(obj)

    it 'should not have a key named "__proto__" initially', ->
        d.has("__proto__").should.equal(false)

    it 'should not allow changing of its `size` property', ->
        expect(-> d.size = 10).to.throw(TypeError)
        d.size.should.equal(0)

    describe 'when an object is inserted into the "__proto__" key', ->
        fakeValue = {}
        proto = { fakeKey: fakeValue }

        beforeEach ->
            d.set("__proto__", proto)

        it "should have an entry for the __proto__ key", ->
            d.has("__proto__").should.equal(true)

        it "should not have any keys derived from the inserted __proto__ object", ->
            d.has("fakeKey").should.equal(false)

        it "should not delete from the inserted __proto__ object when deleting from the dict", ->
            d.delete("fakeKey")
            d.get("__proto__").fakeKey.should.equal(fakeValue)

    describe 'when users forget to use strings as keys', ->
        shouldThrowFor = (value) ->
            expect(-> d.get(value)).to.throw(TypeError)
            expect(-> d.get(value, "fallback")).to.throw(TypeError)
            expect(-> d.set(value)).to.throw(TypeError)
            expect(-> d.has(value)).to.throw(TypeError)
            expect(-> d.delete(value)).to.throw(TypeError)

        it "should throw a `TypeError` when using `undefined`", ->
            shouldThrowFor(undefined)

        it "should throw a `TypeError` when using `null`", ->
            shouldThrowFor(null)

        it "should throw a `TypeError` when using `5`", ->
            shouldThrowFor(5)

        it "should throw a `TypeError` when using a date", ->
            shouldThrowFor(new Date())

        it "should throw a `TypeError` when using a regex", ->
            shouldThrowFor(/key/i)

        it "should throw a `TypeError` when using an object", ->
            shouldThrowFor({})

        it "should throw a `TypeError` when using an object with a toString method", ->
            shouldThrowFor({ toString: -> "key" })
