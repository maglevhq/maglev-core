<template>
  <button
    class="h-7 w-7 flex items-center justify-center rounded-full focus:outline-none transition-colors duration-200"
    :class="{ 
      'bg-gray-600 text-gray-200 hover:bg-gray-900 hover:text-gray-100': dark, 
      'bg-gray-600 bg-opacity-0 hover:text-gray-900 text-gray-800 hover:bg-opacity-10': !dark 
    }"
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
    dark: { type: Boolean, default: false },
  },
}
</script>
