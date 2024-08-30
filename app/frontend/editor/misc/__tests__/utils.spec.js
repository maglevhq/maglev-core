import * as utils from '../utils'
import i18n from '@/plugins/i18n.js'

describe('numberToHumanSize', () => {
  it('takes a number and converts it into a human string', () => {
    expect(utils.numberToHumanSize(2096000, i18n)).toEqual('2.00 MB')
  })
})

describe('camelize', () => {
  it('tests a simple case', () => {
    expect(utils.camelize('foo_bar')).toEqual('fooBar')
    expect(utils.camelize('foo-bar')).toEqual('fooBar')
    expect(utils.camelize('fooBar')).toEqual('fooBar')
    expect(utils.camelize('Foo')).toEqual('foo')
  })
});

describe('camelizeKeys', () => {
  it('tests a simple case', () => {
    expect(utils.camelizeKeys({ 'foo-bar': true })).to.deep.equal({ fooBar: true })
  })

  it('tests an array value', () => {
    expect(utils.camelizeKeys({'Test' : [0,1] })).to.deep.equal({ test: [0, 1] })
  })

  it('tests a 2 depth object', () => {
    expect(utils.camelizeKeys({'foo-bar': {'bar-foo' : true}})).to.deep.equal({ fooBar: { barFoo: true } })
  })

  it('tests a 2 depth object with array value', () => {
    expect(utils.camelizeKeys({'foo-bar': {'bar-foo' : [{'Test': true}]}})).to.deep.equal({'fooBar': {'barFoo' : [{'test': true}]}})
  })

  it('accepts an array of objects', () => {
    expect(utils.camelizeKeys([{foo_bar: true}, {bar_foo: false}, {'bar-foo': 'false'}])).to.deep.equal([{fooBar: true}, {barFoo: false}, {barFoo: 'false'}])
  })

  it('tests a plain object', () => {
    expect(utils.camelizeKeys({ a: new Date('2019-06-07T13:32:21.936Z'), b: { cd: 1234, ef: true } })).to.deep.equal({ a: new Date('2019-06-07T13:32:21.936Z'), b: { cd: 1234, ef: true } })
  })
});