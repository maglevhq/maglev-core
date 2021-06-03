<template>
  <div class="mt-10 flex flex-col">
    <button 
      class="disabled:opacity-75 block w-full px-6 py-3 rounded-sm bg-editor-primary text-white bg-opacity-95 hover:bg-opacity-100 transition-colors duration-200"
      type="button"
      :disabled="disabled"
      @click="$emit('select', link)" 
    >
      {{ $t(`${i18nScope}.mainButton.${mode}`) }}
    </button>

    <button 
      class="block w-full text-gray-800 py-2 hover:bg-gray-100 transition-colors duration-200"
      type="button"
      @click="$emit('on-close')"               
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
    mode: { type: String, default: 'select' },
    disabled: { type: Boolean, default: true },    
  },
  computed: {
    i18nScope() {
      return 'linkPicker.shared'
    }
  },
}
</script>
