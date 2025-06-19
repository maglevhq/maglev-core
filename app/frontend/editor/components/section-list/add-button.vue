<template>
  <div 
    class="absolute left-0 w-full h-7 group bg-red-500/0 z-10"
    :class="{ 
      '-top-5': isTop,
      '-bottom-5': !isTop
    }"
  >
    <!-- <div class="relative hidden group-hover:block h-0.5 w-full bg-gray-600 top-[calc(theme('spacing[7]')/2+theme('spacing[0.5]')/-2)]"></div> -->

    <div class="absolute top-0 left-0 w-full justify-center flex opacity-0 group-hover:opacity-100 transition-opacity duration-200">
      <uikit-icon-button 
        iconName="ri-add-line" 
        dark 
        class="border-4 border-white w-10 h-10" 
        @click="addSection"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: 'SectionListAddButton',
  props: {   
    insertAt: { type: String, required: false },
  },
  computed: {
    isTop() {
      return this.insertAt === 'top'
    },
  },
  methods: {
    addSection() {
      this.$router.push({ name: 'addSectionAfter', params: { sectionId: this.insertAt } })      
    },
  },
}
</script>