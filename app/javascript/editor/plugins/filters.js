import Vue from 'vue'
import { numberToHumanSize, truncate, formatPath } from '@/utils'

Vue.filter('numberToHumanSize', numberToHumanSize)
Vue.filter('truncate', truncate)
Vue.filter('formatPath', formatPath)
