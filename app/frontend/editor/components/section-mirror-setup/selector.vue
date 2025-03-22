<template>
  <div class="space-y-6">
   <uikit-select-input
      :label="$t(`mirrorSectionSetup.page.input.label`)"
      :placeholder="$t(`mirrorSectionSetup.page.input.placeholder`)"
      :searchEnabled="true"
      :searchPlaceholder="$t(`mirrorSectionSetup.page.input.searchPlaceholder`)"
      :emptyLabel="$t(`mirrorSectionSetup.page.input.emptyLabel`)"
      :fetchList="(q) => services.page.findAll({ q })"
      v-model="page"
    >
      <template v-slot:value>
        {{ page.title }}
      </template>
      <template v-slot:item="{ item, hovered }">
        <div class="flex items-center">
          <span class="font-bold">{{ item.title }}</span>
          <span
            class="ml-auto"
            :class="{ 'text-gray-500': !hovered, 'text-white': hovered }"
          >
            {{ item.path | formatPath }}
          </span>
        </div>
      </template>
    </uikit-select-input>

    <uikit-select-input
      :label="$t(`mirrorSectionSetup.page.sectionInput.label`)"
      :placeholder="$t(`mirrorSectionSetup.page.sectionInput.placeholder`)"
      :emptyLabel="$t(`mirrorSectionSetup.page.sectionInput.emptyLabel`)"
      :fetchList="() => fetchPageSectionNames()"
      v-model="pageSection"
      v-if="hasPageSections"
    >
      <template v-slot:value>
        {{ pageSection.name }}
      </template>
      <template v-slot:item="{ item, hovered }">
        <div class="flex items-center">
          <span class="font-bold">{{ item.name }}</span>
          <span
          class="ml-auto"
          :class="{ 'text-gray-500': !hovered, 'text-white': hovered }"
        >
          {{ item.layoutGroupLabel }}
        </span>
        </div>
      </template>
    </uikit-select-input>
  </div>
</template>

<script>
export default {
  name: 'SectionMirrorSetupSelector',
  props: {
    value: { type: Object, required: true }
  },
  data() {
    return { page: null, pageSection: null }
  },
  computed: {
    hasPageSections() {
      return !this.isBlank(this.page?.sectionNames)
    },
  },
  methods: {
    async fetchPageSectionNames() {
      return this.page.sectionNames
    }
  },
  watch: {
    pageSection(newValue) {
      this.$emit('input', {
        pageId: this.page.id,
        pageTitle: this.page.title,
        layoutGroupId: this.pageSection.layoutGroupId,
        sectionId: this.pageSection.id
      })
    }
  }
}
</script>