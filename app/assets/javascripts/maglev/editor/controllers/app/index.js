import { application } from  "maglev-controllers/application"
// import 'maglev-controllers/app/dynamic_form'

import PagePreviewController from "maglev-controllers/app/page_preview_controller"
import PreviewNotificationCenterController from "maglev-controllers/app/preview_notification_center_controller"

import EditorSectionFormController from "maglev-controllers/app/forms/section_form_controller"
import EditorStyleFormController from "maglev-controllers/app/forms/style_form_controller"
import EditorSettingController from "maglev-controllers/app/setting_controller"

application.register("editor-page-preview", PagePreviewController)
application.register("editor-preview-notification-center", PreviewNotificationCenterController)

application.register("editor-section-form", EditorSectionFormController)
application.register("editor-style-form", EditorStyleFormController)
application.register("editor-setting", EditorSettingController)
