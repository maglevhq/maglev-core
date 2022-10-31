const apiService = {
  setSiteHandle: jest.fn(),
  setSiteLocale: jest.fn(),
  get: jest.fn(),
  post: jest.fn(),
  put: jest.fn(),
  destroy: jest.fn(),
}

const siteService = {
  find: jest.fn(),
}

const themeService = {
  buildCategories: jest.fn(),
}

const pageService = {
  isIndex: jest.fn(),
  build: jest.fn(),
  findAll: jest.fn(),
  findById: jest.fn(),
  create: jest.fn(),
  update: jest.fn(),
  updateSettings: jest.fn(),
  setVisible: jest.fn(),
  clone: jest.fn(),
  destroy: jest.fn(),
  normalize: jest.fn(),
  denormalize: jest.fn(),
}

const sectionService = {
  calculateMovingIndices: jest.fn(),
  canBeAddedToPage: jest.fn(),
  normalize: jest.fn(),
  build: jest.fn(),
  getSettings: jest.fn(),
  buildDefaultBlock: jest.fn(),
}

const blockService = {
  encodeToTree: jest.fn(),
  decodeTree: jest.fn(),
}

const imageService = {
  findAll: jest.fn(),
  find: jest.fn(),
  create: jest.fn(),
  destroy: jest.fn(),
}

const livePreviewService = {
  start: jest.fn(),
  updateStyle: jest.fn(),
  addSection: jest.fn(),
  moveSection: jest.fn(),
  updateSection: jest.fn(),
  removeSection: jest.fn(),
  addBlock: jest.fn(),
  moveBlock: jest.fn(),
  updateBlock: jest.fn(),
  removeBlock: jest.fn(),
}

const collectionItemService = {
  findAll: jest.fn(),
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
