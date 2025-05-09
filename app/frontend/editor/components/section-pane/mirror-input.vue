<template>
  <div class="space-y-6">
    <div v-if="!isMirroredSectionEditable" class="bg-gray-100 p-4 rounded-sm">
      <h3 class="font-medium text-gray-900 text-center">{{ $t('mirrorSectionSetup.protectedMessage.title') }}</h3>
      <p class="mt-1 text-sm text-gray-600 text-center">{{ $t('mirrorSectionSetup.protectedMessage.message') }}</p>
    </div>

    <uikit-checkbox-input
      :label="$t('mirrorSectionSetup.inputLabel')"
      :placeholder="placeholder"
      name="mirrorSectionEnabled"
      v-model="mirrorSectionEnabled"
    />
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'

export default {
  name: 'MirrorSectionInput',
  props: {},
  data() {
    return { mirrorSectionEnabled: undefined }
  },
  mounted() {
    this.mirrorSectionEnabled = this.currentSection?.mirrorOf?.enabled
  },
  computed: {
    ...mapGetters(['isMirroredSectionEditable']),
    mirrorOf() {
      return this.currentSection?.mirrorOf
    },
    placeholder() {
      if (!this.mirrorOf) return null
      return `${this.mirrorOf.pageTitle}#${this.mirrorOf.sectionId}`
    }
  },
  methods: {
    ...mapActions(['toggleMirroredSectionEnabled']),
  },
  watch: {
    mirrorSectionEnabled(newValue, oldValue) {
      if (!oldValue && oldValue !== false) return
      this.toggleMirroredSectionEnabled(newValue)
    }
  }
}
</script>
