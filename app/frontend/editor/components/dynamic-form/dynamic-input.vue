<template>
  <div>
    <uikit-text-input
      :label="label"
      :name="setting.id"
      :isFocused="isFocused"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-if="
        setting.type == 'text' &&
        !options.html &&
        parseInt(options.nbRows || 1) < 2
      "
    />
    <uikit-textarea-input
      :label="label"
      :name="setting.id"
      :isFocused="isFocused"
      :rows="options.nbRows"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-if="
        setting.type == 'text' && !options.html && parseInt(options.nbRows) > 1
      "
    />
    <uikit-rich-text-input
      :label="label"
      :name="setting.id"
      :isFocused="isFocused"
      :lineBreak="options.lineBreak"
      :rows="options.nbRows"
      :extraExtensions="options.extraExtensions" 
      @blur="$emit('blur')"
      v-model="inputValue"
      v-if="setting.type == 'text' && options.html"
    />
    <uikit-image-input
      :label="label"
      :name="setting.id"
      :isFocused="isFocused"
      v-model="inputValue"
      v-if="setting.type == 'image'"
    />
    <uikit-icon-input
      :label="label"
      :name="setting.id"
      :isFocused="isFocused"
      v-model="inputValue"
      v-if="setting.type == 'icon'"
    />
    <uikit-checkbox-input
      :label="label"
      :name="setting.id"
      v-model="inputValue"
      v-if="setting.type == 'checkbox'"
    />
    <uikit-link-input
      :label="label"
      :name="setting.id"
      :isFocused="isFocused"
      :withText="options.withText"
      v-model="inputValue"
      v-if="setting.type == 'link'"
    />
    <uikit-color-input
      :label="label"
      :name="setting.id"
      v-model="inputValue"
      :presets="options.presets"
      v-if="setting.type == 'color'"
    />
    <uikit-simple-select
      :label="label"
      :name="setting.id"
      v-model="inputValue"
      :selectOptions="options.selectOptions"
      v-if="setting.type == 'select'"
    />
    <uikit-collection-item-input
      :label="label"
      :name="setting.id"
      v-model="inputValue"
      :collection-id="options.collectionId"
      v-if="setting.type == 'collection_item'"
    />

    <uikit-divider
      :text="label"
      :withHint="options.withHint"
      v-if="setting.type == 'divider'"
    />

    <uikit-hint :text="label" v-if="setting.type == 'hint'" />
  </div>
</template>

<script>
export default {
  name: 'DynamicInput',
  props: {
    setting: { type: Object, default: () => ({ type: 'text' }) },
    content: { type: Array, required: true },
    isFocused: { type: Boolean, default: false },
    i18nScope: { type: String, required: false },
  },
  computed: {
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
