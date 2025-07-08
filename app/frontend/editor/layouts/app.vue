<template>
  <layout id="maglev-app" class="font-nunito overflow-hidden">
    <template v-slot:header>
      <header-nav />
    </template>

    <template v-slot:sidebar>
      <sidebar-nav />
    </template>

    <template v-slot:slide-pane>
      <transition
        name="slide"
        mode="out-in"
        v-on:before-enter="beforeEnter"
        v-on:after-enter="afterEnter">
        <router-view name="slide-pane" />
      </transition>
    </template>

    <router-view />
  </layout>
</template>

<script>
import Layout from '@/layouts/default.vue'
import HeaderNav from '@/components/header-nav/index.vue'
import SidebarNav from '@/components/sidebar-nav/index.vue'

export default {
  name: 'AppLayout',
  components: { Layout, HeaderNav, SidebarNav },
  methods: {
    beforeEnter() {
      this.services.livePreview.simulateFakeScroll()
    },
    afterEnter() {
      this.services.livePreview.pingSection(this.currentSection?.id)
    },
  },
}
</script>
