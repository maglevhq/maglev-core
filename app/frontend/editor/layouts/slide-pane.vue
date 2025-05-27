<template>
  <div
    class="slide-pane absolute inset-y-0 h-full bg-white border-r border-gray-200 origin-top-left flex flex-col"
    :class="{
      'left-0 z-40': $route.meta.hidingSidebar,
      'left-16 z-10': !$route.meta.hidingSidebar,
      'w-1/2': maxWidthPane,
      'w-104': !maxWidthPane,
    }"
  >
    <slot name="header">
      <div class="py-6 mx-4">
        <div class="h-6 flex items-center">
          <slot name="pre-title" v-if="withPreTitle">
            <h2 class="text-lg rounded w-3/4 bg-gray-200 animate-pulse">
              &nbsp;
            </h2>
          </slot>

          <div class="w-full" v-else>
            <h2
              class="text-gray-800 font-semibold antialiased text-lg capitalize-first"
              v-if="title"
            >
              {{ title }}
            </h2>
            <h2 class="text-lg rounded w-3/4 bg-gray-200 animate-pulse" v-else>
              &nbsp;
            </h2>
          </div>

          <div class="ml-auto">
            <router-link :to="{ name: 'editPage' }">
              <uikit-icon-button iconName="ri-close-line" class="relative -right-2" />
            </router-link>
          </div>
        </div>

        <div v-if="withPreTitle">
          <h2
            class="text-gray-800 font-semibold antialiased text-lg capitalize-first"
            v-if="title"
          >
            {{ title }}
          </h2>
          <h2 class="text-lg rounded w-3/4 bg-gray-200 animate-pulse" v-else>
            &nbsp;
          </h2>
        </div>

        <p class="text-gray-400 text-sm" v-if="subTitle">{{ subTitle }}</p>
      </div>
    </slot>

    <div
      class="flex-1 flex flex-col"
      :class="{ 'overflow-y-auto': overflowY, 'overflow-y-hidden': !overflowY }"
    >
      <div
        class="flex-1 flex flex-col"
        :class="{ 'pb-4 mx-4': overflowY, 'overflow-y-hidden': !overflowY }"
      >
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SlidePaneLayout',
  props: {
    title: { type: String, default: undefined },
    subTitle: { type: String, default: undefined },
    overflowY: { type: Boolean, default: true },
    maxWidthPane: { type: Boolean, default: false },
    withPreTitle: { type: Boolean, default: false },
  },
}
</script>

<style scoped>
.slide-pane {
  top: theme('spacing.16');
  height: calc(100% - theme('spacing.16'));
}
</style>
