export const isBlank = (object) => {
  return (
    object === undefined ||
    object === null ||
    (typeof object === 'string' && object.length === 0) ||
    (typeof object === 'object' && object.length === 0)
  )
}

export const capitalize = (str) => {
 return str.slice(0, 1).toUpperCase() + str.slice(1);
}

export const camelize = (str) => {
  return str
    .replace(/^([A-Z])/, (m, chr) => chr.toLowerCase())
    .replace(/(?:_|-)([a-z\d]*)/g, (m, chr) => capitalize(chr))
}

export const camelizeKeys = (obj) => {
  if (Array.isArray(obj)) {
    return obj.map((v) => camelizeKeys(v))
  } else if (obj != null && obj.constructor === Object) {
    return Object.keys(obj).reduce(
      (result, key) => ({
        ...result,
        [camelize(key)]: camelizeKeys(obj[key]),
      }),
      {},
    )
  }
  return obj
}

export const numberToHumanSize = (size, i18n) => {
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
  if (!hex) return null
  var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})?$/i.exec(hex.trim())
  return result
    ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: result[3] ? parseInt(result[3], 16) : 0,
      }
    : null
}

export const colorVariableToHex = (variable) => {
  if (!variable) return null
  const color = (
    variable.startsWith('--')
      ? getComputedStyle(document.body).getPropertyValue(variable)
      : variable
  )
    .trim()
    .toLowerCase()
  return color === 'transparent' ? '' : color
}

export const colorVariableToRgb = (variable) => {
  return hexToRgb(colorVariableToHex(variable))
}

// Static pages have absolute path ("/something") but regular pages have no leading slash
export const formatPath = (path) => {
  return path[0] === '/' ? path : `/${path}`
}

// https://gist.github.com/ahtcx/0cd94e62691f539160b32ecda18af3d6
export const deepMerge = (target, source) => {
  const result = { ...target, ...source }
  const keys = Object.keys(result)

  for (const key of keys) {
    const tprop = target[key]
    const sprop = source[key]
    //if two objects are in conflict
    if (typeof tprop == 'object' && typeof sprop == 'object') {
      result[key] = deepMerge(tprop, sprop)
    }
  }

  return result
}

export const hasChanged = (newObject, oldObject, property) => {
  return (
    !!oldObject[property] &&
    !!newObject[property] &&
    oldObject[property] !== newObject[property]
  )
}

export const hasAnyChanged = (newObject, oldObject, ...properties) => {
  return properties.some((property) =>
    hasChanged(newObject, oldObject, property),
  )
}