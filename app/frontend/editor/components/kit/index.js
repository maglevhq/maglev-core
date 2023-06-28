import Vue from 'vue'
import { VPopover } from 'v-tooltip'
import Icon from './icon.vue'
import ModalRoot from './modal-root.vue'
import Modal from './modal.vue'
import Tabs from './tabs.vue'
import Accordion from './accordion.vue'
import Dropdown from './dropdown.vue'
import ConfirmationButton from './confirmation-button.vue'
import SubmitButton from './submit-button.vue'
import ImageInput from './image-input.vue'
import IconInput from './icon-input.vue'
import LinkInput from './link-input.vue'
import SelectInput from './select-input.vue'
import TextAreaInput from './textarea-input.vue'
import TextInput from './text-input.vue'
import RichTextInput from './rich-text-input.vue'
import CheckboxInput from './checkbox-input.vue'
import SearchInput from './search-input.vue'
import Pagination from './pagination/index.vue'
import PageIcon from './page-icon.vue'
import ColorInput from './color-input.vue'
import SimpleSelect from './simple-select.vue'
import CollectionItemInput from './collection-item-input.vue'
import ListItemButton from './list-item-button.vue'

Vue.component('icon', Icon)
Vue.component('v-popoper', VPopover)
Vue.component('dropdown', Dropdown)
Vue.component('modal-root', ModalRoot)
Vue.component('modal', Modal)
Vue.component('tabs', Tabs)
Vue.component('accordion', Accordion)
Vue.component('confirmation-button', ConfirmationButton)
Vue.component('submit-button', SubmitButton)
Vue.component('image-input', ImageInput)
Vue.component('icon-input', IconInput)
Vue.component('link-input', LinkInput)
Vue.component('select-input', SelectInput)
Vue.component('textarea-input', TextAreaInput)
Vue.component('text-input', TextInput)
Vue.component('rich-text-input', RichTextInput)
Vue.component('checkbox-input', CheckboxInput)
Vue.component('search-input', SearchInput)
Vue.component('pagination', Pagination)
Vue.component('page-icon', PageIcon)
Vue.component('color-input', ColorInput)
Vue.component('simple-select', SimpleSelect)
Vue.component('collection-item-input', CollectionItemInput)
Vue.component('list-item-button', ListItemButton)
