<template>  
  <div class="mt-4">
    <tabs 
      :tabs="tabs" 
      :otherProps="{ page, errors }"
      sharedClass="px-1/2"
      @on-change="onChange"
    />
    <div class="mt-4">
      <submit-button 
        type="button"
        class="block text-white w-full px-6 py-3 bg-opacity-95 hover:bg-opacity-100 transition-colors duration-200" 
        defaultColorClass="bg-editor-primary"
        :labels="$t('page.new.submitButton')"    
        :buttonState="submitState"
        @click="createPage"
      >
        {{ $t('page.new.submitButton') }}
      </submit-button>
      <button 
        class="block w-full text-gray-800 py-2 hover:bg-gray-100 transition-colors duration-200"
        @click="$emit('on-close')"
      >
        {{ $t('page.new.cancelButton') }}
      </button>
    </div>
  </div>
</template>

<script>
import MainForm from './form/main'
import SEOForm from './form/seo'

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
    createPage() {      
      this.submitState = 'inProgress'
      this.services.page.create(this.page)
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
    }
  }
}
</script>
