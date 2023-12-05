import EditorEN from './editor.en.json'
import EditorES from './editor.es.json'
import EditorFR from './editor.fr.json'
import EditorPTBR from './editor.pt-BR.json'
import { deepMerge } from '@/misc/utils'

const overriddenEN = window.customTranslations?.en ?? {}
const overriddenES = window.customTranslations?.es ?? {}
const overriddenFR = window.customTranslations?.fr ?? {}
const overriddenPTBR =
  window.customTranslations && window.customTranslations['pt-BR']
    ? window.customTranslations['pt-BR']
    : {}

export default {
  en: deepMerge(EditorEN, overriddenEN),
  es: deepMerge(EditorES, overriddenES),
  fr: deepMerge(EditorFR, overriddenFR),
  'pt-BR': deepMerge(EditorPTBR, overriddenPTBR),
}
