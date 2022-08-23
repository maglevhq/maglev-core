// import { VPopover } from 'v-tooltip'
import Icon from './kit-icon.vue'
import ModalRoot from './kit-modal-root.vue'
import Modal from './kit-modal.vue'
// import Tabs from './tabs.vue'
// import Accordion from './accordion.vue'
// import Dropdown from './dropdown.vue'
// import ConfirmationButton from './confirmation-button.vue'
// import SubmitButton from './submit-button.vue'
// import ImageInput from './image-input.vue'
// import IconInput from './icon-input.vue'
// import LinkInput from './link-input.vue'
// import SelectInput from './select-input.vue'
// import TextAreaInput from './textarea-input.vue'
// import TextInput from './text-input.vue'
// import RichTextInput from './rich-text-input.vue'
// import CheckboxInput from './checkbox-input.vue'
// import SearchInput from './search-input.vue'
// import Pagination from './pagination/index.vue'
// import PageIcon from './page-icon.vue'
// import ColorPicker from './color-picker.vue'
// import SimpleSelect from './simple-select.vue'
// import CollectionItemInput from './collection-item-input.vue'
// import ListItemButton from './list-item-button.vue'

const createUIKit = (app) => {
  app.component('kit-icon', Icon)
  // app.component('v-popoper', VPopover)
  // app.component('dropdown', Dropdown)
  app.component('kit-modal-root', ModalRoot)
  app.component('kit-modal', Modal)
  // app.component('tabs', Tabs)
  // app.component('accordion', Accordion)
  // app.component('confirmation-button', ConfirmationButton)
  // app.component('submit-button', SubmitButton)
  // app.component('image-input', ImageInput)
  // app.component('icon-input', IconInput)
  // app.component('link-input', LinkInput)
  // app.component('select-input', SelectInput)
  // app.component('textarea-input', TextAreaInput)
  // app.component('text-input', TextInput)
  // app.component('rich-text-input', RichTextInput)
  // app.component('checkbox-input', CheckboxInput)
  // app.component('search-input', SearchInput)
  // app.component('pagination', Pagination)
  // app.component('page-icon', PageIcon)
  // app.component('color-picker', ColorPicker)
  // app.component('simple-select', SimpleSelect)
  // app.component('collection-item-input', CollectionItemInput)
  // app.component('list-item-button', ListItemButton)
}

export default createUIKit
