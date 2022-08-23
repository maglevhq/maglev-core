import { createI18n } from 'vue-i18n'
import messages from '@/locales'

const AVAILABLE_LOCALES = ['en', 'fr']
var locale = 'en'

if (document.documentElement.lang) {
  // fetch the local from the HTML tag
  locale = document.documentElement.lang
} else {
  // try to fetch the browser locale
  const language = navigator.languages[0]
  if (language) {
    locale = language.split('-')[0]
    if (AVAILABLE_LOCALES.indexOf(locale) === -1) locale = null
  }
}

const i18n = createI18n({
  // legacy: false,
  // globalInjection: true,
  locale,
  fallbackLocale: AVAILABLE_LOCALES[0],
  messages,
})

export default i18n
