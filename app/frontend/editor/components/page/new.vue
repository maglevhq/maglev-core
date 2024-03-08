<template>
  <div class="flex flex-col flex-1 overflow-y-hidden">
    <uikit-tabs
      :tabs="tabs"
      :otherProps="{ page, errors }"
      navClass="mx-1"
      panelClass=""
      class="overflow-y-hidden pb-4"
      @on-change="onChange"
    />
    <div class="mt-auto">
      <uikit-submit-button
        type="button"
        class="big-submit-button"
        defaultColorClass="bg-editor-primary"
        :labels="$t('page.new.submitButton')"
        :buttonState="submitState"
        @click="createPage"
      >
        {{ $t('page.new.submitButton') }}
      </uikit-submit-button>
      <button class="cancel-button" @click="$emit('on-close')">
        {{ $t('page.new.cancelButton') }}
      </button>
    </div>
  </div>
</template>

<script>
import MainForm from './form/main.vue'
import SEOForm from './form/seo.vue'

export default {
  name: 'NewPage',
  data() {
    return { page: {}, errors: {}, submitState: 'default' }
  },
  mounted() {
    this.page = this.services.page.build()
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
    createPage() {
      this.submitState = 'inProgress'
      this.services.page
        .create(this.page)
        .then(() => {
          this.submitState = 'success'
          this.$emit('on-close')
          this.$emit('on-refresh')
        })
        .catch(({ response: { status, data } }) => {
          console.log('[Maglev] could not create the page', status)
          this.submitState = 'fail'
          if (status !== 400) return
          this.errors = data.errors
        })
    },
    onChange(changes) {
      this.page = { ...this.page, ...changes }
    },
  },
}
</script>
