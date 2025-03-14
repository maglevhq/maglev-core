import * as api from './api'
import buildSiteService from './site'
import * as theme from './theme'
import buildPageService from './page'
import buildSectionsContentService from './sections-content'
import buildCollectionItemService from './collection-item'
import buildImageService from './image'
import * as section from './section'
import * as block from './block'
import * as livePreview from './live-preview'

export default {
  api,
  site: buildSiteService(api),
  theme,
  page: buildPageService(api),
  sectionsContent: buildSectionsContentService(api),
  section,
  block,
  image: buildImageService(api),
  livePreview,
  collectionItem: buildCollectionItemService(api),
}
