<template>
  <div>
    <button
      v-if="!isTableActive"
      class="block h-full rounded-sm px-2 py-2 bg-gray-100 hover:bg-gray-200 flex items-center focus:outline-none focus:ring"
      @click="insertTable"
    >
      <icon name="ri-table-2" class="w-4 h-4 text-dark" />
    </button>

    <dropdown placement="bottom" ref="dropdown" v-else>
      <template v-slot:button>
        <button
          class="rounded-sm px-2 py-2 bg-gray-100 hover:bg-gray-200 flex items-center focus:outline-none focus:ring"
        >
          <icon name="ri-table-2" class="w-4 h-4 text-dark" />
          <icon name="arrow-down-s-line" class="ml-1" />
        </button>
      </template>

      <template v-slot:content>
        <div class="w-full flex space-x-2">
          <button
            class="py-2 px-3 hover:bg-gray-200"
            @click="commands.deleteTable"
          >
            <icon name="delete-bin-line" class="w-4 h-4 text-dark" />
          </button>
          <button
            class="py-2 px-3 hover:bg-gray-200"
            @click="commands.addColumnBefore"
          >
            <icon name="ri-insert-column-left" class="w-4 h-4 text-dark" />
          </button>
          <button
            class="py-2 px-3 hover:bg-gray-200"
            @click="commands.addColumnAfter"
          >
            <icon name="ri-insert-column-right" class="w-4 h-4 text-dark" />
          </button>
          <button
            class="py-2 px-3 hover:bg-gray-200"
            @click="commands.deleteColumn"
          >
            <icon name="ri-delete-column" class="w-4 h-4 text-dark" />
          </button>
          <button
            class="py-2 px-3 hover:bg-gray-200"
            @click="commands.addRowBefore"
          >
            <icon name="ri-insert-row-top" class="w-4 h-4 text-dark" />
          </button>
          <button
            class="py-2 px-3 hover:bg-gray-200"
            @click="commands.addRowAfter"
          >
            <icon name="ri-insert-row-bottom" class="w-4 h-4 text-dark" />
          </button>
          <button
            class="py-2 px-3 hover:bg-gray-200"
            @click="commands.deleteRow"
          >
            <icon name="ri-delete-row" class="w-4 h-4 text-dark" />
          </button>
        </div>
      </template>
    </dropdown>
  </div>
</template>

<script>
export default {
  name: 'EditorTableButton',
  props: {
    commands: { type: Object, required: true },
    isActive: { type: Object, required: true },
  },
  computed: {
    isTableActive() {
      return this.isActive.table()
    },
    iconName() {
      if (this.isActive.heading({ level: 2 })) return 'format-heading-2'
      else if (this.isActive.heading({ level: 3 })) return 'format-heading-3'
      else if (this.isActive.heading({ level: 4 })) return 'format-heading-4'
      else if (this.isActive.blockquote()) return 'format-blockquote'
      else if (this.isActive.code_block()) return 'format-code'
      else return 'ri-table-line'
    },
  },
  methods: {
    insertTable() {
      this.commands.createTable({
        rowsCount: 3,
        colsCount: 3,
        withHeaderRow: true,
      })
    },
  },
  watch: {
    iconName() {
      this.$refs.dropdown.close()
    },
  },
}
</script>
