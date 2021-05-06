<template>  
  <div class="mt-4">
    <tabs 
      :tabs="tabs" 
      :otherProps="{ page: editedPage, errors }"
      sharedClass="px-1/2"
      @on-change="onChange"
    />
    <div class="mt-4">
      <submit-button 
        type="button"
        class="block text-white w-full px-6 py-3 bg-opacity-95 hover:bg-opacity-100 transition-colors duration-200" 
        defaultColorClass="bg-editor-primary"
        :labels="$t('page.edit.submitButton')"    
        :buttonState="submitState"
        @click="updatePage"
      >
        {{ $t('page.new.submitButton') }}
      </submit-button>
      <button 
        class="block w-full text-gray-800 py-2 hover:bg-gray-100 transition-colors duration-200"
        @click="$emit('on-close')"
      >
        {{ $t('page.edit.cancelButton') }}
      </button>
    </div>
  </div>
</template>

<script>
import MainForm from './form/main'
import SEOForm from './form/seo'

export default {
  name: 'EditPage', 
  props: {
    page: { type: Object, required: true }
  },
  data() {
    return { editedPage: null, errors: {}, submitState: 'default' }
  },
  computed: {
    tabs() {
      return [
        { 
          name: this.$t('page.new.tabs.main'), 
          tab: MainForm, 
          type: 'main' 
        },
        { 
          name: this.$t('page.new.tabs.seo'), 
          tab: SEOForm, 
          type: 'seo' 
        },
      ]
    },
  },
  methods: {
    updatePage() {      
      this.submitState = 'inProgress'
      const { id: pageId, ...attributes } = this.editedPage
      this.services.page.updateSettings(pageId, attributes)
      .then(() => {
        this.submitState = 'success'
        this.$emit('on-update', attributes)        
      })
      .catch(({ response: { status, data } }) => {
        console.log('[Maglev] could not update the page', status)
        this.submitState = 'fail'
        if (status !== 400) return
        this.errors = data.errors        
      })
    },
    onChange(changes) {
      this.editedPage = { ...this.editedPage, ...changes }
    }
  },
  watch: {
    page: {
      immediate: true,
      handler() {
        console.log('...', this.page)
        this.editedPage = { ...this.page }
      },
    }
  }
}
</script>
