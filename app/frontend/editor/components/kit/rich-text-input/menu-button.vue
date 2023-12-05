<template>
  <button
    class="px-2 py-2 bg-gray-100 hover:bg-gray-200 focus:outline-none focus:ring"
    :class="{
      'bg-gray-400 hover:bg-gray-400': isActive,
      'bg-gray-100': !isActive,
    }"
    @click="$emit('click')"
  >
    <uikit-icon :name="iconName" class="w-4 h-4 text-dark" />
  </button>
</template>

<script>
export default {
  name: 'EditorMenuButton',
  props: {
    isActive: { type: Boolean, default: false },
    iconName: { type: String, default: 'format-bold' },
  },
}
</script>
