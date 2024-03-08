<template>
  <form
    @submit.stop.prevent="search"
    class="flex items-center py-2 px-4 rounded bg-gray-100 text-gray-800 focus:outline-none focus:ring"
  >
    <button class="mr-2" type="submit">
      <uikit-icon name="search-line" class="text-gray-500" />
    </button>

    <input
      name="search-input"
      type="text"
      v-model="query"
      class="block w-full border-0 bg-transparent focus:outline-none placeholder-gray-500"
      :placeholder="placeholder"
      :aria-label="placeholder"
    />

    <button
      class="ml-1 text-gray-500"
      :class="{ invisible: !query }"
      @click.stop.prevent="reset"
      type="button"
    >
      <uikit-icon name="close-line" />
    </button>
  </form>
</template>

<script>
export default {
  name: 'UIKitSearchInput',
  props: {
    placeholder: { type: String, default: 'Type your query here' },
  },
  data() {
    return {
      query: null,
    }
  },
  methods: {
    search() {
      const cleanQuery =
        (this.query || '').trim().length > 0 ? this.query.trim() : null
      // console.log(`searching for ${cleanQuery}`);
      this.$emit('search', cleanQuery)
    },
    reset() {
      this.query = null
      this.$emit('search', null)
    },
  },
}
</script>
