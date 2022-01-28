import i18n from '@/plugins/i18n.js'

export const isBlank = (object) => {
  return (
    object === undefined ||
    object === null ||
    (typeof object === 'string' && object.length === 0) ||
    (typeof object === 'object' && object.length === 0)
  )
}

export const camelize = (str) => {
  return str
    .toLowerCase()
    .replace(/[^a-zA-Z0-9]+(.)/g, (m, chr) => chr.toUpperCase())
}

export const numberToHumanSize = (size) => {
  if (isBlank(size)) return null

  let number, unit
  if (size < 1024) (number = size), (unit = 'byte')
  else if (size < 1024.0 * 1024.0)
    (number = (size / 1024.0).toFixed(2).replace('.00', '')), (unit = 'kb')
  else if (size < 1024.0 * 1024.0 * 1024.0)
    (number = (size / 1024.0 / 1024.0).toFixed(2)), (unit = 'mb')
  else (number = (size / 1024.0 / 1024.0 / 1024.0).toFixed(2)), (unit = 'gb')

  let translatedUnit = i18n.tc(
    `support.human.storageUnits.units.${unit}`,
    number,
  )

  return i18n.t(`support.human.storageUnits.format`, {
    number,
    unit: translatedUnit,
  })
}

export const debounce = (fn, time) => {
  let timeoutId
  function wrapper(...args) {
    if (timeoutId) {
      clearTimeout(timeoutId)
    }
    timeoutId = setTimeout(() => {
      timeoutId = null
      fn(...args)
    }, time)
  }
  return wrapper
}

export const arraymove = (array, fromIndex, toIndex) => {
  let newArray = [...array]
  var element = array[fromIndex]
  newArray.splice(fromIndex, 1)
  newArray.splice(toIndex, 0, element)
  return newArray
}

export const uuid = (length) => {
  let charset =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'
  let i
  let result = ''
  if (window.crypto && window.crypto.getRandomValues) {
    let values = new Uint32Array(length)
    window.crypto.getRandomValues(values)
    for (i = 0; i < length; i++) {
      result += charset[values[i] % charset.length]
    }
    return result
  } else
    throw new Error(
      "Your browser is too old and can't generate secure random numbers",
    )
}

export const uuid8 = () => uuid(8)

export const truncate = (value, limit) => {
  if (value.length > limit) {
    value = value.substring(0, limit - 3) + '...'
  }
  return value
}

// Like pick of Lodash but without the Lodash dependency
export const pick = (obj, ...args) => ({
  ...args.reduce((res, key) => ({ ...res, [key]: obj[key] }), {}),
})

// Remove undefined values from an object
export const omitEmpty = (obj) =>
  Object.keys(obj).forEach((key) => obj[key] === undefined && delete obj[key])

export const hexToRgb = (hex) => {
  var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  return result
    ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16),
      }
    : null
}

// Static pages have absolute path ("/something") but regular pages have no leading slash
export const formatPath = (path) => {
  return path[0] === '/' ? path : `/${path}`
}
