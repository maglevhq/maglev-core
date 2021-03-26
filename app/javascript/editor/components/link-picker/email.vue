<template>
  <div>
    <text-input 
      :label="$t(`linkPicker.email.input.label`)"
      name="email"
      v-model="link.email"      
    />

    <link-picker-actions :link="link" :disabled="isBlank(link.email)" v-on="$listeners" />
  </div>
</template>

<script>
import LinkPickerActions from './actions'

export default {
  name: 'LinkEmailPicker',
  components: { LinkPickerActions },
  props: {
    currentLink: { type: Object, default: undefined },
  }, 
  data() {
    return { link: { linkType: 'email', linkId: null, email: null } }
  },
  watch: {
    currentLink: {
      immediate: true,
      async handler(currentLink) {
        if (!currentLink || this.isBlank(currentLink.href)) return        
        const matching = (/^mailto:(.*)$/g).exec(currentLink.href)
        this.link.href = currentLink.href
        this.link.email = matching && matching[1] ? matching[1] : null
      }
    },
    'link.email'() {
      this.link.href = `mailto:${this.link.email}`      
    }
  },
}
</script>
