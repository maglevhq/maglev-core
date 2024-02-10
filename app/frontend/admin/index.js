// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.
import { Application } from 'stimulus'
import { registerControllers } from 'stimulus-vite-helpers'

const application = Application.start()
const controllers = import.meta.glob('./**/*_controller.js', { eager: true })
registerControllers(application, controllers)

window.stimulusApplication = application
