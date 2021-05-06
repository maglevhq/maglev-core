<template>
  <div>
    <dynamic-input 
      v-for="(setting, index) in settings"
      :key="[parentKey, setting.id].join()"
      :class="{ 'mt-4': index !== 0 }"      
      :setting="setting"
      :content="content"
      :isFocused="focusedSetting === setting.id"
      @blur="$emit('blur')"
      @change="onChange"
    />    
  </div>
</template>

<script>
import DynamicInput from './dynamic-input'

export default {
  name: 'DynamicForm',
  components: { DynamicInput },
  props: {
    parentKey: { type: String, default: '' },
    settings: { type: Array, default: () => [] },
    content: { type: Array, default: () => [] },
    focusedSetting: { type: String, default: undefined },
  },
  methods: {    
    onChange(change) {
      this.$emit('change', change)
    },    
  },  
}
</script>
