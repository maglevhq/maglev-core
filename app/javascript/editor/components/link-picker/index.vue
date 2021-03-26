<template>
  <modal v-if="show" @close="$emit('close')">
    <h3 class="text-gray-800 font-semibold antialiased text-lg" slot="header">
      {{ $t('linkPicker.title') }}
    </h3>

    <div class="mt-4" slot="body">
      <tabs 
        :tabs="tabs" 
        :firstIndex="firstTabIndex"
        :otherProps="{ currentLink }"
        @onChange="link => $emit('set', link)" 
        @close="$emit('close')" 
      />     
    </div>
  </modal>
</template>

<script>
import PagePicker from './page'
import UrlPicker from './url'
import EmailPicker from './email'

export default {
  name: 'LinkPicker',
  components: { PagePicker, UrlPicker, EmailPicker },
  props: {
    currentLink: { type: Object, default: undefined },
    show: { type: Boolean, default: false },
  },  
  computed: {
    tabs() {
      return [
        { name: this.$t('linkPicker.page.name'), tab: PagePicker, type: 'page' },
        { name: this.$t('linkPicker.url.name'), tab: UrlPicker, type: 'url' },
        { name: this.$t('linkPicker.email.name'), tab: EmailPicker, type: 'email' },
      ]
    },
    firstTabIndex() {
      let type = this.currentLink?.linkType
      let href = this.currentLink?.href

      if (!type && href && href.startsWith('mailto:')) type = 'email'
      if (!type) type = 'url'

      return this.tabs.map(t => t.type).indexOf(type)      
    },
  }
}
</script>