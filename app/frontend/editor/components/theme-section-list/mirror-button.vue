<template>
  <div class="text-center">
    <button @click="openSetupModal" class="inline-block px-4 py-4 hover:bg-gray-100 transition-colors">{{ $t('mirrorSectionSetup.addButton') }}</button>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import SectionMirrorSetup from '@/components/section-mirror-setup/index.vue'

export default {
  name: 'MirrorSectionButton',
  components: { SectionMirrorSetup },
  props: {
    layoutGroupId: { type: String, required: true },
    insertAfter: { type: String },
  },
  methods: {
    ...mapActions(['addMirroredSection']),
    openSetupModal() {
      this.openModal({
        title: this.$t('mirrorSectionSetup.title'),
        component: SectionMirrorSetup,
        props: { modalClass: 'w-120 h-144' },
        listeners: {
          setup: (source) => this.onSetup(source),
        },
      })
    },
    onSetup(source) {
      this.closeModal()
      this.addMirroredSection({
        source,
        target: {
          layoutGroupId: this.layoutGroupId,
          insertAt: this.insertAfter,
        }
      }).then(() => {
        this.$router.push({ name: 'editPage' })
      })
    },
  }
}
</script>
