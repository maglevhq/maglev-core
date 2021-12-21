import buildService from '../page'
import MockedServices from '@/spec/__mocks__/services'
import { page } from '@/spec/__mocks__/page'

describe('PageService', () => {
  let service = null

  beforeEach(() => {
    service = buildService(MockedServices.api)
  })

  describe('#normalize', () => {
    it('takes a Page object and normalize it into entities', () => {
      const output = service.normalize(page)
      expect(output.result).toEqual(1)
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
      expect(output.entities.page['1'].sections).toStrictEqual([
        'GrYZW-VP',
        '8hKSujtd',
        'xM6f-kyh',
      ])
    })
  })
})
