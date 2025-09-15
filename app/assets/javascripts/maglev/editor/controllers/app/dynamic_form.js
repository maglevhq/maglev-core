import { application } from  "maglev-controllers/application"

import SectionFormController from "inputs-controllers/forms/section_form_controller"
import StyleFormController from "inputs-controllers/forms/style_form_controller"

import InputController from "inputs-controllers/input_controller"

import ImageInputController from "inputs-controllers/image/image_controller"
import SelectInputController from "inputs-controllers/select/select_controller"

application.register("editor-section-form", SectionFormController)
application.register("editor-style-form", StyleFormController)

application.register("editor-input", InputController)
application.register("editor-image-input", ImageInputController)
application.register("editor-select-input", SelectInputController)
