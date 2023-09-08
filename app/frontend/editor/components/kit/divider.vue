<template>
  <div class="py-4">
    <div class="relative">
      <div class="absolute inset-0 flex items-center" aria-hidden="true">
        <div class="w-full border-t border-gray-200"></div>
      </div>
      <div class="relative flex justify-center">
        <span class="bg-white px-3 leading-6 text-gray-800">{{ text }}</span>
      </div>
    </div>
    <div v-if="hasHint" class="mt-4 text-gray-600 text-sm">{{ hint }}</div>
  </div>
</template>

<script>
export default {
  name: 'Divider',
  props: {
    text: { type: String, default: 'Text goes here' },
    hint: { type: String, default: null }
  },
  computed: {
    hasHint() {
      return !this.isBlank(this.hint)
    }
  }
}
</script>