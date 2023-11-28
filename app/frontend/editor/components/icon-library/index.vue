<template>
  <div class="space-y-2">
    <div>
      <uikit-search-input @search="(q) => (query = q)" />
    </div>
    <div class="overflow-y-auto h-64">
      <div class="grid grid-cols-6 gap-2 pt-2 pb-8">
        <div
          v-for="(icon, index) in icons"
          :key="`icon-${index}`"
          class="flex justify-center"
        >
          <div
            class="cursor-pointer text-gray-900 h-12 w-12 flex items-center justify-center rounded hover:bg-gray-900 hover:text-white hover:shadow-lg transition transform duration-200 ease-in-out hover:scale-125"
            @click.prevent="$emit('select', icon)"
          >
            <i class="text-3xl" :class="icon"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'IconLibrary',
  data() {
    return { query: null }
  },
  computed: {
    icons() {
      const icons = this.currentTheme.icons || []
      if (this.isBlank(this.query)) return icons
      return icons.filter((icon) => icon.includes(this.query))
    },
  },
}
</script>
