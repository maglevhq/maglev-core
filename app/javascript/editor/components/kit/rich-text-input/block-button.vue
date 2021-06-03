<template>
  <dropdown placement="left" ref="dropdown">
    <template v-slot:button>
      <button
        class="rounded-sm px-2 py-2 bg-gray-100 hover:bg-gray-200 flex items-center focus:outline-none focus:shadow-outline"
      >
        <icon 
          :name="iconName"
          class="w-4 h-4 text-dark"      
        />
        <icon name="arrow-down-s-line" class="ml-1" />
      </button>
    </template>

    <template v-slot:content>
      <div class="w-full flex">
        <button class="py-2 px-3 hover:bg-gray-200" @click="commands.paragraph">
          <icon name="format-paragraph" />
        </button>
        <button class="py-2 px-3 hover:bg-gray-200" @click="commands.heading({ level: 2 })">
          <icon name="format-heading-2" />
        </button>
        <button class="py-2 px-3 hover:bg-gray-200" @click="commands.heading({ level: 3 })">
          <icon name="format-heading-3" />
        </button>
        <button class="py-2 px-3 hover:bg-gray-200" @click="commands.blockquote">
          <icon name="format-blockquote" />
        </button>
        <button class="py-2 px-3 hover:bg-gray-200" @click="commands.code_block">
          <icon name="format-code" />
        </button>
      </div>
    </template>
  </dropdown>
</template>

<script>
export default {
  name: 'EditorBlockButton',
  props: {
    commands: { type: Object, required: true },
    isActive: { type: Object, required: true },
  },
  computed: {
    iconName() {
      if (this.isActive.heading({ level: 2 }))
        return 'format-heading-2'
      else if (this.isActive.heading({ level: 3 }))
        return 'format-heading-3'
      else if (this.isActive.blockquote())
        return 'format-blockquote'
      else if (this.isActive.code_block())
        return 'format-code'
      else
        return 'format-paragraph'
    }
  },
  watch: {
    iconName() {
      this.$refs.dropdown.close()
    }
  }
}
</script>