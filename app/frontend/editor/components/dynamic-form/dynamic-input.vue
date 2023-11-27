<template>
  <div>
    <text-input
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
    <textarea-input
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
    <rich-text-input
      :label="label"
      :name="setting.id"
      :isFocused="isFocused"
      :lineBreak="options.lineBreak"
      :rows="options.nbRows"
      :table="options.htmlTable"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-if="setting.type == 'text' && options.html"
    />
    <image-input
      :label="label"
      :name="setting.id"
      :isFocused="isFocused"
      v-model="inputValue"
      v-if="setting.type == 'image'"
    />
    <icon-input
      :label="label"
      :name="setting.id"
      :isFocused="isFocused"
      v-model="inputValue"
      v-if="setting.type == 'icon'"
    />
    <checkbox-input
      :label="label"
      :name="setting.id"
      v-model="inputValue"
      v-if="setting.type == 'checkbox'"
    />
    <link-input
      :label="label"
      :name="setting.id"
      :isFocused="isFocused"
      :withText="options.withText"
      v-model="inputValue"
      v-if="setting.type == 'link'"
    />
    <color-input
      :label="label"
      :name="setting.id"
      v-model="inputValue"
      :presets="options.presets"
      v-if="setting.type == 'color'"
    />
    <simple-select
      :label="label"
      :name="setting.id"
      v-model="inputValue"
      :selectOptions="options.selectOptions"
      v-if="setting.type == 'select'"
    />
    <collection-item-input
      :label="label"
      :name="setting.id"
      v-model="inputValue"
      :collection-id="options.collectionId"
      v-if="setting.type == 'collection_item'"
    />

    <divider
      :text="label"
      :withHint="options.withHint"
      v-if="setting.type == 'divider'"
    />

    <hint :text="label" v-if="setting.type == 'hint'" />
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
