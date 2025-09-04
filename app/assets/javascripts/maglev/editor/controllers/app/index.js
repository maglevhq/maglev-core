import { application } from  "maglev-controllers/application"

import PagePreviewController from "maglev-controllers/app/page_preview_controller"
import PreviewNotificationCenterController from "maglev-controllers/app/preview_notification_center_controller"

import SectionFormController from "inputs-controllers/forms/section_form_controller"

import TextInputController from "inputs-controllers/text/text_controller"
import ImageInputController from "inputs-controllers/image/image_controller"

application.register("editor-page-preview", PagePreviewController)
application.register("editor-preview-notification-center", PreviewNotificationCenterController)

application.register("editor-section-form", SectionFormController)

application.register("editor-text-input", TextInputController)
application.register("editor-image-input", ImageInputController)