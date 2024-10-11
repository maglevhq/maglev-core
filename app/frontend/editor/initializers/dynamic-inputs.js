import { registerInput, getInputs } from '@/misc/dynamic-inputs'

import TextInput from '@/components/kit/polymorphic-text-input.vue'
import ImageInput from '@/components/kit/image-input.vue'
import LinkInput from '@/components/kit/link-input.vue'
import SimpleSelect from '@/components/kit/simple-select.vue'
import CollectionItemInput from '@/components/kit/collection-item-input.vue'
import CheckboxInput from '@/components/kit/checkbox-input.vue'
import ColorInput from '@/components/kit/color-input.vue'
import IconInput from '@/components/kit/icon-input.vue'
import Divider from '@/components/kit/divider.vue'
import Hint from '@/components/kit/hint.vue'

registerInput('text', TextInput, (props, options) => ({ ...props, options }))
registerInput('image', ImageInput)
registerInput('link', LinkInput, (props, options) => ({ ...props, withText: options.withText }))
registerInput('select', SimpleSelect, (props, options) => ({ ...props, selectOptions: options.selectOptions }))
registerInput('collection_item', CollectionItemInput, (props, options) => ({ ...props, collectionId: options.collectionId }))
registerInput('checkbox', CheckboxInput)
registerInput('icon', IconInput)
registerInput('color', ColorInput, (props, options) => ({ ...props, presets: options.presets }))
registerInput('divider', Divider, (props, options) => ({ text: props.label, withHint: options.withHint }))
registerInput('hint', Hint, (props, options) => ({ text: props.label }))