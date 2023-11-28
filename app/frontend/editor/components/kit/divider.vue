<template>
  <div :class="{ 'pt-4': withHint, 'pt-4 pb-2': !withHint }">
    <div class="relative">
      <div class="absolute inset-0 flex items-center" aria-hidden="true">
        <div class="w-full border-t border-gray-200"></div>
      </div>
      <div class="relative flex justify-center">
        <span class="bg-white px-3 leading-6 text-gray-800">{{ text }}</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UIKitDivider',
  props: {
    text: { type: String, default: 'Text goes here' },
    withHint: { type: Boolean, default: false },
  },
}
</script>
