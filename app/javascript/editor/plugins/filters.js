import Vue from 'vue'
import i18n from '@/plugins/i18n.js'
import { numberToHumanSize, truncate, formatPath } from '@/misc/utils'

Vue.filter('numberToHumanSize', (size) => numberToHumanSize(size, i18n))
Vue.filter('truncate', truncate)
Vue.filter('formatPath', formatPath)
