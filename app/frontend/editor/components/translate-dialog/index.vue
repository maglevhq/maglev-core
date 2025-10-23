<template>
  <div class="flex flex-col space-y-8">

    <i18n
      path="translateDialog.description"
      tag="div"
      class="text-gray-700"
    >
      <template v-slot:locale>
        <strong class="text-gray-900">{{ localeName }}</strong>
      </template>
      <template v-slot:sourceLocale>
        <strong class="text-gray-900">{{ sourceLocaleName }}</strong>
      </template>
    </i18n>

    <div>
      <uikit-submit-button
        type="button"
        class="big-submit-button"
        defaultColorClass="bg-editor-primary"
        :labels="$t('translateDialog.submitButton')"
        :buttonState="submitState"
        @click="translate"
      >
        {{ $t('page.edit.submitButton') }}
      </uikit-submit-button>
      <button
        class="cancel-button"
        @click="$emit('on-close')"
      >
        {{ $t('translateDialog.cancelButton') }}
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TranslateDialog',
  data() {
    return { submitState: 'default', pollingSubmission: false, pollingInterval: null }
  },
  computed: {
    localeName() {
      return this.$t(`support.locales.${this.currentLocale}`)
    },
    sourceLocaleName() {
      return this.$t(`support.locales.${this.currentDefaultLocale}`)
    }
  },
  unmounted() {
    if (this.pollingInterval) clearInterval(this.pollingInterval)
  },
  methods: {
    translate() {
      this.submitState = 'inProgress'
      this.services.page.translate(this.currentPage.id, this.currentLocale)
      .then(() => {
        this.pollingSubmission = true
        // Force a refresh
        // this.$nextTick(() => { this.$router.go(0) })
      })
      .catch(() => {
        this.submitState = 'fail'        
      })
    },
    isTranslated() {
      this.services.page.isTranslated(this.currentPage.id, this.currentLocale)
      .then((translated) => {
        if (translated) {
          this.pollingSubmission = false
          // Force a refresh
          this.$nextTick(() => { this.$router.go(0) })
        }
      })
      .catch(() => {
        this.pollingSubmission = false
        this.submitState = 'fail'
      })
    }
  },
  watch: {
    pollingSubmission(newValue, oldValue) {
      if (!newValue) {
        if (this.pollingInterval) clearInterval(this.pollingInterval)
        return
      }

      this.pollingInterval = setInterval(() => this.isTranslated(), 1000)
    }
  }
}
</script>