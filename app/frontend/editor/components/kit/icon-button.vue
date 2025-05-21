<template>
  <button
    class="px-1.5 py-1.5 rounded-full bg-gray-600 bg-opacity-0 hover:text-gray-900 text-gray-800 focus:outline-none hover:bg-opacity-10 transition-colors duration-200"
    v-on="$listeners"
    v-bind="$attrs"
  >
    <uikit-icon :name="iconName" size="1.15rem" />
  </button>
</template>

<script>
export default {
  name: 'UIKitIconButton',
  inheritAttrs: false,
  props: {
    iconName: { type: String, required: true },
  },
}
</script>
