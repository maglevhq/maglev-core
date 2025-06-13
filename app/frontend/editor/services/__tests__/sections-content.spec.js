import buildService from '../sections-content'
import MockedServices from '@/spec/__mocks__/services'
import { sectionsContent } from '@/spec/__mocks__/sections-content'

describe('SectionsContentService', () => {
  let service = null

  beforeEach(() => {
    service = buildService(MockedServices.api)
  })

  describe('#normalize', () => {
    it('takes a SectionsContent object and normalize it into entities', () => {
      const output = service.normalize(sectionsContent)
      expect(output.result).toEqual(['header', 'main', 'footer'])
      expect(Object.keys(output.entities.sections)).toStrictEqual([
        'GrYZW-VP',
        '8hKSujtd',
        'xM6f-kyh',
      ])
      expect(Object.keys(output.entities.blocks)).toStrictEqual([
        'RiEo8C3f',
        'P1fGieWs',
        'sDo-Dg85',
        'K-C_zRcH',
        'fNIEuzF0',
        'UVGOFAI5',
        'K3Xotn7f',
        'Pst6WyU0',
      ])
      expect(output.entities.layoutGroups.header.sections).toStrictEqual(['GrYZW-VP'])
    })
  })
})
