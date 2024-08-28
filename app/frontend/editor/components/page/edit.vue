<template>
  <div class="flex flex-col flex-1 overflow-y-hidden">
    <uikit-tabs
      :tabs="tabs"
      :otherProps="{ page: editedPage, errors }"
      :navClass="!insideModal ? 'mx-4' : 'mx-1'"
      :panelClass="!insideModal ? 'mx-3' : ''"
      class="overflow-y-hidden pb-4"
      @on-change="onChange"
    />
    <div class="mt-auto" :class="{ 'mx-4': !insideModal }">
      <uikit-submit-button
        type="button"
        class="big-submit-button"
        defaultColorClass="bg-editor-primary"
        :labels="$t('page.edit.submitButton')"
        :buttonState="submitState"
        @click="updatePage"
      >
        {{ $t('page.edit.submitButton') }}
      </uikit-submit-button>
      <button
        class="cancel-button"
        v-if="insideModal"
        @click="$emit('on-close')"
      >
        {{ $t('page.edit.cancelButton') }}
      </button>
    </div>
  </div>
</template>

<script>
import MainForm from './form/main.vue'
import SEOForm from './form/seo.vue'

export default {
  name: 'EditPage',
  props: {
    page: { type: Object, required: true },
    insideModal: { type: Boolean, default: false },
  },
  data() {
    return { editedPage: null, errors: {}, submitState: 'default' }
  },
  computed: {
    tabs() {
      return [
        {
          name: this.$t('page.form.tabs.main'),
          tab: MainForm,
          type: 'main',
        },
        {
          name: this.$t('page.form.tabs.seo'),
          tab: SEOForm,
          type: 'seo',
        },
      ]
    },
  },
  methods: {
    updatePage() {
      this.submitState = 'inProgress'
      const { id: pageId, ...attributes } = this.editedPage
      this.services.page
        .updateSettings(pageId, {
          ...attributes,
          lockVersion: this.page.lockVersion,
        })
        .then(({ headers }) => {
          this.submitState = 'success'
          this.$emit('on-update', {
            ...attributes,
            lockVersion: headers['page-lock-version'],
          })
        })
        .catch(({ response: { status, data } }) => {
          console.log('[Maglev] could not update the page', status)
          this.submitState = 'fail'
          if (status === 409) this.openErrorModal('staleRecord')
          if (status !== 400) return
          this.errors = data.errors
        })
    },
    onChange(changes) {
      this.editedPage = { ...this.editedPage, ...changes }
    },
  },
  watch: {
    page: {
      immediate: true,
      handler() {
        this.editedPage = { ...this.page }
      },
    },
  },
}
</script>
