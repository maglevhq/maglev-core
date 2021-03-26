<template>
  <div>
    <text-input 
      :label="$t(`linkPicker.url.input.label`)"
      name="href"
      v-model="link.href"      
    />

    <checkbox-input
      :label="$t(`linkPicker.shared.newWindowInput.label`)"
      name="openNewWindow"
      class="mt-6"
      v-model="link.openNewWindow"
    />
    
    <link-picker-actions :link="link" :disabled="isBlank(link.href)" v-on="$listeners" />    
  </div>
</template>

<script>
import LinkPickerActions from './actions'

export default {
  name: 'LinkUrlPicker',
  components: { LinkPickerActions },
  props: {
    currentLink: { type: Object, default: undefined },
  }, 
  data() {
    return { link: { linkType: 'url', linkId: null, href: null, openNewWindow: true } }
  }, 
  watch: {
    currentLink: {
      immediate: true,
      async handler(currentLink) {
        if (!currentLink) return        
        this.link.openNewWindow = currentLink.target === '_blank'
        this.link.href = currentLink.href
      }
    },
  },
}
</script>
