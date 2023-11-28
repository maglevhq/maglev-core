<template>
  <layout
    :title="$t('page.list.title')"
    :sub-title="$t('page.list.subTitle')"
    :overflowY="false"
  >
    <div class="h-full flex flex-col px-4 pb-4">
      <div class="py-2">
        <uikit-search-input
          @search="search"
          class="py-4"
          :placeholder="$t('page.list.searchPlaceholder')"
        />
      </div>
      <div class="flex-1 overflow-y-auto">
        <page-list :q="q" class="h-full pt-2" ref="list" />
      </div>
      <div class="pt-4" v-if="canAddPage">
        <button
          @click="openNewPageModal"
          class="big-submit-button bg-editor-primary"
        >
          {{ $t('page.list.newButton') }}
        </button>
      </div>
    </div>
  </layout>
</template>

<script>
import Layout from '@/layouts/slide-pane.vue'
import PageList from '@/components/page/list/index.vue'
import NewPageModal from '@/components/page/new.vue'

export default {
  name: 'PageListView',
  components: { Layout, PageList },
  data() {
    return { q: null }
  },
  computed: {
    canAddPage() {
      return this.currentLocale === this.currentSite.locales[0].prefix
    },
  },
  methods: {
    search(q) {
      this.q = q
    },
    openNewPageModal() {
      this.openModal({
        title: this.$t('page.new.title'),
        component: NewPageModal,
        closeOnClick: false,
        props: {
          modalClass: 'w-120 h-144',
        },
        listeners: {
          'on-refresh': () => this.$refs.list.fetch(),
        },
      })
    },
  },
}
</script>
