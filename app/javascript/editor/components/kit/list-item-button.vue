<template>
  <button
    class="
      px-1
      py-1
      rounded-full
      bg-gray-600 bg-opacity-0
      hover:text-gray-900
      text-gray-600
      focus:outline-none
      hover:bg-opacity-10
      transition-colors
      duration-200
    "
  >
    <icon :name="iconName" size="1.25rem" />
  </button>
</template>

<script>
export default {
  name: 'ListItemButton',
  props: {
    iconName: { type: String, required: true },
  },
}
</script>
