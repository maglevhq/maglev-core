<template>
  <div>
    <dynamic-input 
      v-for="(setting, index) in settings"
      :key="[parentKey, setting.id].join()"
      :class="{ 'mt-4': index !== 0 }"      
      :setting="setting"
      :value="content[setting.id]"
      :isFocused="focusedSetting === setting.id"
      @blur="$emit('blur')"
      @change="onChange"
    />    
  </div>
</template>

<script>
export default {
  name: 'DynamicForm',
  props: {
    parentKey: { type: String, default: '' },
    settings: { type: Array, default: () => [] },
    content: { type: Object, default: () => {} },
    focusedSetting: { type: String, default: undefined },
  },
  methods: {
    onChange(change) {
      this.$emit('change', change)
    },    
  },  
}
</script>
