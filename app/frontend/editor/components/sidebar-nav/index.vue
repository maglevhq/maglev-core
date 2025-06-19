<template>
  <nav class="w-16 flex flex-col justify-between">
    <div
      class="flex justify-center h-full w-full animate-pulse"
      v-if="!currentPage"
    >
      <div class="w-6 bg-gray-200 rounded h-48 my-6"></div>
    </div>
    <ol class="divide-y divide-gray-300 px-4" v-else>
      <li>
        <sidebar-nav-link
          routerLinkName="listPages"
          :active="isListPagesActive"
          iconName="ri-file-copy-line"
          :tooltipMessage="$t('sidebarNav.listPagesTooltip')"
        />
      </li>
      <li>
        <sidebar-nav-link
          :routerLinkName="'listSections'"
          :active="isSectionListPaneActive"
          iconName="ri-stack-line"
          :tooltipMessage="$t('sidebarNav.managePageSectionsTooltip')"        
        />
      </li>
      <li v-if="hasStyle">
        <sidebar-nav-link
          :routerLinkName="'editStyle'"
          :active="isEditStylePaneActive"
          iconName="ri-drop-line"
          iconSize="1.25rem"
          :tooltipMessage="$t('sidebarNav.editStyleTooltip')"        
        />        
      </li>
      <li>
        <sidebar-nav-link
          :isRouterLink="false"
          iconName="image-line"
          :tooltipMessage="$t('sidebarNav.openImageLibraryTooltip')"
          @click.prevent="openImageLibraryModal"
        />        
      </li>      
      <li></li>
    </ol>

    <ol class="divide-y divide-gray-300 px-4">
      <li></li>
      <li>
        <sidebar-nav-link
          :isRouterLink="false"
          :linkUrl="leaveEditorUrl"
          iconName="logout-box-r-line"
          :tooltipMessage="$t('sidebarNav.leaveEditorTooltip')"
        />
      </li>
    </ol>
  </nav>
</template>

<script>
import ImageLibrary from '@/components/image-library/index.vue'
import SidebarNavLink from './link.vue'

export default {
  name: 'SidebarNav',
  components: { 
    SidebarNavLink 
  },
  computed: {
    hasStyle() {
      return !this.isBlank(this.currentStyle)
    },
    isListPagesActive() {
      return this.$route.name === 'listPages'
    },
    isAddSectionPaneActive() {
      return this.$route.name === 'addSection'
    },
    isSectionListPaneActive() {
      return this.$route.name === 'listSections'
    },
    isEditStylePaneActive() {
      return this.$route.name === 'editStyle'
    },
    isEditPageActive() {
      return this.$route.name === 'editPageSettings'
    },
    leaveEditorUrl() {
      return window.leaveUrl
    },
  },
  methods: {
    openImageLibraryModal() {
      this.openModal({
        title: this.$t('imageLibrary.title'),
        component: ImageLibrary,
        props: { modalClass: 'w-216' },
      })
    },
  },
}
</script>
