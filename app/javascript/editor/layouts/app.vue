<template>
  <layout id="maglev-app" class="font-nunito overflow-hidden">
    <template v-slot:header>
      <header-nav />
    </template>
    
    <template v-slot:sidebar>
      <sidebar-nav />
    </template>

    <template v-slot:slide-pane>
      <transition name="slide" mode="out-in">
        <router-view name="slide-pane" />
      </transition>
    </template>
    
    <router-view />
  </layout>
</template>

<script>
import Layout from '@/layouts/default'
import HeaderNav from '@/components/header-nav'
import SidebarNav from '@/components/sidebar-nav'

export default {
  name: 'AppLayout',
  components: { Layout, HeaderNav, SidebarNav }
}
</script>
