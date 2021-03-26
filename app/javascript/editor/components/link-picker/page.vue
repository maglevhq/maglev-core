<template>
  <div>
    <select-input 
      :label="$t(`linkPicker.page.input.label`)"
      :placeholder="$t(`linkPicker.page.input.placeholder`)"
      :searchPlaceholder="$t(`linkPicker.page.input.searchPlaceholder`)"
      :emptyLabel="$t(`linkPicker.page.input.emptyLabel`)"
      v-model="link.page"      
      :fetchList="q => services.page.findAll(currentSite, { q })"
    >
      <template v-slot:value>
        {{ link.page.title }}
      </template>
      <template v-slot:item="{ item, hovered }">
        <div class="flex items-center">
          <span class="font-bold">{{ item.title }}</span>
          <span 
            class="ml-auto" 
            :class="{ 'text-gray-500': !hovered, 'text-white': hovered }"
          >
            /{{ item.path }}
          </span>
        </div>
      </template>
    </select-input>

    <checkbox-input
      :label="$t(`linkPicker.shared.newWindowInput.label`)"      
      name="openNewWindow"
      class="mt-6"
      v-model="link.openNewWindow"
    />
    
    <link-picker-actions :link="link" :disabled="isBlank(link.page)" v-on="$listeners" />
  </div>
</template>

<script>
import LinkPickerActions from './actions'

export default {  
  name: 'LinkPagePicker',
  components: { LinkPickerActions },
  props: {
    currentLink: { type: Object, default: undefined },
  }, 
  data() {
    return { link: { linkType: 'page', linkId: null, page: null, openNewWindow: true } }
  },    
  watch: {
    currentLink: {
      immediate: true,
      async handler(currentLink) {
        if (!currentLink || currentLink.linkType !== 'page') return
        this.link.openNewWindow = currentLink.target === '_blank'
        this.link.page = await this.services.page.findById(this.currentSite, currentLink.linkId)
      }
    },
    'link.page'() {
      if (!this.link.page) return
      this.link.linkId = this.link.page.id
      this.link.href = `/${this.link.page.path}`      
    }
  }
}
</script>
