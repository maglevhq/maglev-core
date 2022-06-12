import DynamicInputMixin from '@/mixins/dynamic-input'

import TextInput from './text'
import ImageInput from './image'
import ColorInput from './color'
import LinkInput from './link'
import CheckboxInput from './checkbox'
import SelectInput from './select'
import IconInput from './icon'
import CollectionItemInput from './collection-item'

let registeredInputs = {}

// key names must be "underscored" (since they're coming from the Rails API)
const CORE_INPUTS = {
  text: TextInput,
  image: ImageInput,
  color: ColorInput,
  link: LinkInput,
  checkbox: CheckboxInput,
  select: SelectInput,
  icon: IconInput,
  collection_item: CollectionItemInput,
}

export const register = (type, component) => {
  registeredInputs[type] = component
}

export const get = (type) => {
  const component = registeredInputs[type] || CORE_INPUTS[type]

  if (!component) {
    console.log(`[Maglev] we couldn't find a component for the "${type}" type`)
  }

  return component
}

window.registerMaglevSetting = register
window.maglevSettingMixin = DynamicInputMixin
