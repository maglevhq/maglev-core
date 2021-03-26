<template>
  <div class="mt-10 flex flex-col">
    <button 
      class="disabled:opacity-75 bg-editor-primary rounded-sm text-white py-2 px-4 disabled:bg-red-400"
      type="button"
      :disabled="disabled"
      @click="$emit('onChange', link)" 
    >
      {{ $t(`${i18nScope}.addButton`) }}
    </button>

    <button 
      class="text-gray-600 hover:text-gray-800 mt-4"
      type="button"
      @click="$emit('close')"               
    >
      {{ $t(`${i18nScope}.cancelButton`) }}        
    </button>
  </div>
</template>

<script>
export default {
  name: 'LinkPickerActions',
  props: {
    link: { type: Object, required: true },
    disabled: { type: Boolean, default: true },    
  },
  computed: {
    i18nScope() {
      return 'linkPicker.shared'
    }
  },
}
</script>
