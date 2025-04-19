<template>
  <div class="flex flex-col h-full">
    <uikit-tabs
      :tabs="tabs"
      :firstIndex="firstTabIndex"
      :otherProps="{ currentLink: link }"
      navClass="px-1"
      :enableOverflow="false"
      @select-tab="onTabSelected"
      @change="onChange"
    />

    <picker-actions
      :link="link"
      :mode="mode"
      :disabled="!isValid"
      v-on="$listeners"
    />
  </div>
</template>

<script>
import PickerActions from './actions.vue'
import PagePicker from './page.vue'
import UrlPicker from './url.vue'
import EmailPicker from './email.vue'

export default {
  name: 'LinkPicker',
  components: { PickerActions },
  props: {
    currentLink: { type: Object, default: undefined },
    mode: { type: String, default: 'select' },
  },
  data() {
    return { linkType: null, linksByTypes: {} }
  },
  computed: {
    tabs() {
      return [
        {
          name: this.$t('linkPicker.page.name'),
          tab: PagePicker,
          type: 'page',
          subType: 'static_page',
        },
        { name: this.$t('linkPicker.url.name'), tab: UrlPicker, type: 'url' },
        {
          name: this.$t('linkPicker.email.name'),
          tab: EmailPicker,
          type: 'email',
        },
      ]
    },
    firstTabIndex() {
      return this.tabs.findIndex(
        (tab) => this.linkType === tab.type || this.linkType === tab.subType,
      )
    },
    link() {
      return (
        this.linksByTypes[this.linkType] || {
          linkType: this.linkType,
          linkId: null,
          href: null,
          email: null,
          openNewWindow: false,
        }
      )
    },
    isValid() {
      return this.link && !this.isBlank(this.link.href)
    },
  },
  methods: {
    onTabSelected(index) {
      this.linkType = this.tabs[index].type
    },
    onChange(link) {
      const linkType = link.linkType || this.linkType
      this.linksByTypes = {
        ...this.linksByTypes,
        [this.linkType]: { ...link, linkType },
      }
    },
  },
  watch: {
    currentLink: {
      immediate: true,
      handler(link) {
        this.linkType = link?.linkType || 'url'
        this.linksByTypes[this.linkType] = link
      },
    },
  },
}
</script>
