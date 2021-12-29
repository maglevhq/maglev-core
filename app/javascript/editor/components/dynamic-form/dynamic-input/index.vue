<template>
  <component
    v-bind:is="inputComponent"
    :setting="setting"
    :value="value"
    :isFocused="isFocused"
    :options="options"
    v-on="$listeners"
  ></component>
</template>

<script>
import * as InputDictionnary from './dictionnary'

export default {
  name: 'DynamicInput',
  props: {
    setting: { type: Object, default: () => ({ type: 'text' }) },
    content: { type: Array, required: true },
    isFocused: { type: Boolean, default: false },
  },
  computed: {
    inputComponent() {
      return InputDictionnary.get(this.setting.type)
    },
    options() {
      return this.setting.options
    },
    value() {
      const content = this.content.find(
        (sectionContent) => sectionContent.id === this.setting.id,
      )
      return content?.value
    },
  },
}
</script>
