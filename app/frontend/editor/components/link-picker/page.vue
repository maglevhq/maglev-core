<template>
  <div>
    <uikit-select-input
      :label="$t(`linkPicker.page.input.label`)"
      :placeholder="$t(`linkPicker.page.input.placeholder`)"
      :searchEnabled="true"
      :searchPlaceholder="$t(`linkPicker.page.input.searchPlaceholder`)"
      :emptyLabel="$t(`linkPicker.page.input.emptyLabel`)"
      :fetchList="(q) => services.page.findAll({ q })"
      v-model="page"
      listClass="overflow-y-scroll h-48"
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

    <div class="mt-6" v-if="hasPageSections">
      <uikit-select-input
        :label="$t(`linkPicker.page.sectionInput.label`)"
        :placeholder="$t(`linkPicker.page.sectionInput.placeholder`)"
        :emptyLabel="$t(`linkPicker.page.sectionInput.emptyLabel`)"
        :fetchList="() => fetchPageSectionNames()"
        :clearEnabled="true"
        v-model="pageSection"
        listClass="overflow-y-scroll h-48"
      >
        <template v-slot:value>
          {{ pageSection.name }}
        </template>
        <template v-slot:item="{ item }">
          <div class="flex items-center">
            <span class="font-bold">{{ item.name }}</span>
          </div>
        </template>
      </uikit-select-input>
    </div>

    <uikit-checkbox-input
      :label="$t(`linkPicker.shared.newWindowInput.label`)"
      name="openNewWindow"
      class="mt-6"
      v-model="openNewWindowInput"
    />
  </div>
</template>

<script>
export default {
  name: 'LinkPagePicker',
  props: {
    currentLink: { type: Object, default: undefined },
  },
  data() {
    return { page: null, pageSection: null }
  },
  computed: {
    openNewWindowInput: {
      get() {
        return this.currentLink.openNewWindow
      },
      set(openNewWindow) {
        this.$emit('change', { ...this.currentLink, openNewWindow })
      },
    },
    hasPageSections() {
      return !this.isBlank(this.page?.sectionNames)
    },
  },
  methods: {
    async fetchPageSectionNames() {
      return this.page.sectionNames
    },
  },
  watch: {
    currentLink: {
      immediate: true,
      async handler(currentLink) {
        if (
          !currentLink ||
          (currentLink.linkType !== 'page' &&
            currentLink.linkType !== 'static_page') ||
          this.isBlank(currentLink.linkId) ||
          currentLink.linkId === this.page?.id
        )
          return
        this.page = await this.services.page.findById(
          this.currentSite,
          currentLink.linkId,
        )
        if (this.page)
          this.pageSection = this.page.sectionNames.find(
            (item) => item.id === currentLink.sectionId,
          )
      },
    },
    page(page) {
      this.$emit('change', {
        ...this.currentLink,
        linkType: page.static ? 'static_page' : 'page',
        linkId: page.id,
        linkLabel: page.title,
        sectionId: null,
        href: `/${page.path}`,
      })
    },
    pageSection(pageSection) {
      this.$emit('change', {
        ...this.currentLink,
        sectionId: pageSection?.id || null,
      })
    },
  },
}
</script>
