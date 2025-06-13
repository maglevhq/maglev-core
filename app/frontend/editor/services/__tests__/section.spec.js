import * as service from '../section'
import {
  simpleContentSection,
  navContentSection,
} from '@/spec/__mocks__/section'
import { theme } from '@/spec/__mocks__/theme'

describe('SectionService', () => {
  describe('#normalize', () => {
    it('takes a Section object and normalize it into entities', () => {
      const output = service.normalize(simpleContentSection)
      // console.log(JSON.stringify(output))
      expect(output.result).toEqual('NEW-CONTENT-1')
      expect(Object.keys(output.entities.sections)).toStrictEqual([
        'NEW-CONTENT-1',
      ])
    })
    it('takes a Section object with blocks and normalize it into entities', () => {
      const output = service.normalize(navContentSection)
      // console.log(JSON.stringify(output))
      expect(output.result).toEqual('NEW-NAV-CONTENT-1')
      expect(Object.keys(output.entities.sections)).toStrictEqual([
        'NEW-NAV-CONTENT-1',
      ])
      expect(Object.keys(output.entities.blocks)).toStrictEqual([
        'RiEo8C3f',
        'P1fGieWs',
        'sDo-Dg85',
        'K-C_zRcH',
      ])
    })
  })
  describe('#getSectionLabel', () => {
    it('returns the label of the section', () => {
      const label = service.getSectionLabel(simpleContentSection, theme.sections[0])
      expect(label).toEqual('preTitle')
    })
  })
})
