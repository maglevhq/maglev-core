import * as utils from '../utils'
import i18n from '@/plugins/i18n.js'

describe('numberToHumanSize', () => {
  it('takes a number and converts it into a human string', () => {
    expect(utils.numberToHumanSize(2096000, i18n)).toEqual('2.00 MB')
  })
})