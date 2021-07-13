<template>
  <layout :title="$t('page.list.title')" :sub-title="$t('page.list.subTitle')">
    <div class="h-full flex flex-col">
      <div class="pt-2">
        <search-input @search="search" class="py-4" />
      </div>
      <div class="flex-grow overflow-y-auto">
        <page-list :q="q" class="h-full mt-4" ref="list" />
      </div>
      <div class="pt-4">
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
  methods: {
    search(q) {
      this.q = q
    },
    openNewPageModal() {
      this.openModal({
        title: this.$t('page.new.title'),
        component: NewPageModal,
        closeOnClick: false,
        listeners: {
          'on-refresh': () => this.$refs.list.fetch(),
        },
      })
    },
  },
}
</script>
