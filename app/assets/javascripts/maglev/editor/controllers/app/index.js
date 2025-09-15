import { application } from  "maglev-controllers/application"
import 'maglev-controllers/app/dynamic_form'

import PagePreviewController from "maglev-controllers/app/page_preview_controller"
import PreviewNotificationCenterController from "maglev-controllers/app/preview_notification_center_controller"

application.register("editor-page-preview", PagePreviewController)
application.register("editor-preview-notification-center", PreviewNotificationCenterController)