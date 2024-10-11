<template>
  <component 
    :is="inputComponent"
    v-bind="{...inputProps}"
    v-model="inputValue"
    @blur="$emit('blur')"
    v-if="inputComponent" 
  />
</template>

<script>
import { getInput } from '@/misc/dynamic-inputs'

export default {
  name: 'DynamicInput',
  props: {
    setting: { type: Object, default: () => ({ type: 'text' }) },
    content: { type: Array, required: true },
    isFocused: { type: Boolean, default: false },
    i18nScope: { type: String, required: false },
  },
  computed: {
    inputComponent() {
      return getInput(this.setting.type)?.component
    },
    inputProps() {
      const input = getInput(this.setting.type)

      if (!input) return {}

      return input.transformProps({ 
        label: this.label, 
        name: this.name, 
        isFocused: this.isFocused
      }, this.options)
    },
    label() {
      // i18n key examples:
      // - themes.simple.style.settings.main_color
      // - themes.simple.sections.navbar_01.settings.title
      const i18nKey = `${this.i18nScope}.${this.setting.id}`
      const translation = !this.isBlank(this.i18nScope)
        ? this.$st(i18nKey)
        : null
      return translation || this.setting.label
    },
    name() {
      return this.setting.id
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
    inputValue: {
      get() {
        return this.value
      },
      set(value) {
        this.$emit('change', {
          settingId: this.setting.id,
          settingType: this.setting.type,
          settingOptions: this.setting.options,
          value,
        })
      },
    },
  },
}
</script>
