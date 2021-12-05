<template>
  <layout :title="$t('page.list.title')" :sub-title="$t('page.list.subTitle')">
    <div class="h-full flex flex-col">
      <div class="pt-2">
        <search-input
          @search="search"
          class="py-4"
          :placeholder="$t('page.list.searchPlaceholder')"
        />
      </div>
      <div class="flex-grow overflow-y-auto">
        <page-list :q="q" class="h-full mt-4" ref="list" />
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
import Layout from '@/layouts/slide-pane'
import PageList from '@/components/page/list'
import NewPageModal from '@/components/page/new'

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
