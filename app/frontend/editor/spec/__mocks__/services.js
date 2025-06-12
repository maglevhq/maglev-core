import { vi } from 'vitest'

const apiService = {
  setSiteHandle: vi.fn(),
  setSiteLocale: vi.fn(),
  get: vi.fn(),
  post: vi.fn(),
  put: vi.fn(),
  destroy: vi.fn(),
}

const siteService = {
  find: vi.fn(),
}

const themeService = {
  buildCategories: vi.fn()
}

const pageService = {
  isIndex: vi.fn(),
  build: vi.fn(),
  findAll: vi.fn(),
  findById: vi.fn(),
  create: vi.fn(),
  update: vi.fn(),
  updateSettings: vi.fn(),
  setVisible: vi.fn(),
  clone: vi.fn(),
  destroy: vi.fn(),
  normalize: vi.fn(),
  denormalize: vi.fn(),
}

const sectionService = {
  calculateMovingIndices: vi.fn(),
  canBeAddedToPage: vi.fn(),
  normalize: vi.fn(),
  build: vi.fn(),
  getSettings: vi.fn(),
  buildDefaultBlock: vi.fn(),
  getSectionLabel: vi.fn(),
}

const blockService = {
  encodeToTree: vi.fn(),
  decodeTree: vi.fn(),
}

const imageService = {
  findAll: vi.fn(),
  find: vi.fn(),
  create: vi.fn(),
  destroy: vi.fn(),
}

const livePreviewService = {
  start: vi.fn(),
  updateStyle: vi.fn(),
  addSection: vi.fn(),
  moveSection: vi.fn(),
  updateSection: vi.fn(),
  removeSection: vi.fn(),
  addBlock: vi.fn(),
  moveBlock: vi.fn(),
  updateBlock: vi.fn(),
  removeBlock: vi.fn(),
}

const collectionItemService = {
  findAll: vi.fn(),
}

export default {
  api: apiService,
  site: siteService,
  theme: themeService,
  page: pageService,
  section: sectionService,
  block: blockService,
  image: imageService,
  livePreview: livePreviewService,
  collectionItem: collectionItemService,
}
