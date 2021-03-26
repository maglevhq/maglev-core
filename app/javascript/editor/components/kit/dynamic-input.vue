<template>
  <div>
    <text-input 
      :label="setting.label"
      :name="setting.id"
      :isFocused="isFocused"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-if="setting.type == 'text' && !options.html && parseInt(options.nbRows || 1) < 2"
    />
    <textarea-input 
      :label="setting.label"
      :name="setting.id"
      :isFocused="isFocused"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-if="setting.type == 'text' && !options.html && parseInt(options.nbRows) > 1"
    />
    <rich-text-input
      :label="setting.label"
      :name="setting.id"
      :isFocused="isFocused"
      :lineBreak="options.lineBreak"
      :rows="options.nbRows"
      @blur="$emit('blur')"  
      v-model="inputValue"      
      v-if="setting.type == 'text' && options.html"
    />
    <image-input
      :label="setting.label"
      :name="setting.id"
      v-model="inputValue"     
      v-if="setting.type == 'image_picker'"
    />
    <checkbox-input
      :label="setting.label"
      :name="setting.id"
      v-model="inputValue"     
      v-if="setting.type == 'checkbox'"
    />
  </div>  
</template>

<script>
export default {
  name: 'DynamicInput',
  props: {
    setting: { type: Object, default: () => ({ type: 'text' }) },
    value: { required: true },
    isFocused: { type: Boolean, default: false },
  },
  computed: {
    options() {
      return this.setting.options
    },
    inputValue: {
      get() { return this.value },
      set(value) { 
        this.$emit('change', { 
          settingId: this.setting.id, 
          settingType: this.setting.type, 
          value 
        }) 
      }
    }
  },
}
</script>