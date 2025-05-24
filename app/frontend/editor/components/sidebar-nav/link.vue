<template>
  <component 
    :is="isRouterLink ? 'router-link' : 'a'"
    v-bind="linkProps"
    v-on="$listeners"
    class="flex justify-center py-5 -ml-4 -mr-4 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
    :class="{
      'bg-white': !active,
      'bg-editor-primary bg-opacity-5': active,
    }"
    v-tooltip.right="tooltipMessage"
  >
    <uikit-icon :name="iconName" :size="iconSize" />
  </component>
</template>

<script>
export default {
  name: 'SidebarNavLink',
  props: {
    isRouterLink: {
      type: Boolean,
      default: true,
    },
    routerLinkName: {
      type: String,
      required: false,
    },
    linkUrl: {
      type: String,
      default: '#',
      required: false,
    },
    active: {
      type: Boolean,
      default: false,
    },
    iconName: {
      type: String,
      required: true,
    },
    iconSize: {
      type: String,
      default: '1.5rem',
    },
    tooltipMessage: {
      type: String,
      default: null,
      required: false,
    },
  },
  computed: {
    linkProps() {
      return this.isRouterLink ? {
        to: { name: this.routerLinkName },
      } : { href: this.linkUrl }
    },
  },
}
</script>