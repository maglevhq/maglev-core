<template>
  <div>
    <uikit-checkbox-input
      :label="$t('mirrorSectionSetup.inputLabel')"
      :placeholder="placeholder"
      name="mirrorSectionEnabled"
      v-model="mirrorSectionEnabled"
    />

    <pre>{{ currentSection?.mirrorOf }}</pre>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

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
