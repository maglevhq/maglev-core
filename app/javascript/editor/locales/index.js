import EditorEN from './editor.en.json'
import EditorFR from './editor.fr.json'
import { deepMerge } from '@/utils'

const overriddenEN = window.customTranslations?.en ?? {}
const overriddenFR = window.customTranslations?.fr ?? {}

export default {
  en: deepMerge(EditorEN, overriddenEN),
  fr: deepMerge(EditorFR, overriddenFR),
}
