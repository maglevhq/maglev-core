import Vue from 'vue'
import { numberToHumanSize, truncate } from '@/utils'

Vue.filter('numberToHumanSize', numberToHumanSize)
Vue.filter('truncate', truncate)
