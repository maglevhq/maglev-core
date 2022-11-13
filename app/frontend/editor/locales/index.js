import EditorEN from './editor.en.json'
import EditorES from './editor.es.json'
import EditorFR from './editor.fr.json'
import { deepMerge } from '@/misc/utils'

const overriddenEN = window.customTranslations?.en ?? {}
const overriddenES = window.customTranslations?.es ?? {}
const overriddenFR = window.customTranslations?.fr ?? {}

export default {
  en: deepMerge(EditorEN, overriddenEN),
  es: deepMerge(EditorES, overriddenES),
  fr: deepMerge(EditorFR, overriddenFR),
}
