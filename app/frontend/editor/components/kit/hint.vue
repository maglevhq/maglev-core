<template>
  <div class="py-4 text-gray-600 text-sm">{{ text }}</div>
</template>

<script>
export default {
  name: 'Hint',
  props: {
    text: { type: String, default: 'Hint goes here' },
  }
}
</script>