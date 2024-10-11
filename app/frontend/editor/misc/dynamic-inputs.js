const dynamicInputs = {}

const defaultTransformProps = (props, options) => props

export const registerInput = function(name, component, transformProps = null) {
  dynamicInputs[name] = { 
    component, 
    transformProps: transformProps ?? defaultTransformProps 
  }
}

export const getInput = function(name) {
  const input = dynamicInputs[name]

  if (!input) console.log(`⚠️ Unable to find the ${name} type input. Are you sure you registered it correctly?`)

  return dynamicInputs[name]
}

export const getInputs = function() {
  return dynamicInputs
}
