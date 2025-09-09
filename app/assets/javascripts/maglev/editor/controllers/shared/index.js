import { application } from  "maglev-controllers/application"

import DisappearanceController from "maglev-controllers/shared/disappearance_controller"
import MaxLengthController from "maglev-controllers/shared/max_length_controller"
import CopyToClipboardController from "maglev-controllers/shared/copy_to_clipboard_controller"
import TransitionController from "maglev-controllers/shared/transition_controller"
import DispatcherController from "maglev-controllers/shared/dispatcher_controller"
import PreventSamePathController from "maglev-controllers/shared/prevent_same_path"
import SortableController from "maglev-controllers/shared/sortable_controller"
import BrokenImageController from "maglev-controllers/shared/broken_image_controller"
import AutoSaveController from "maglev-controllers/shared/auto_save_controller"
import FormRefreshController from "maglev-controllers/shared/form_refresh_controller"

application.register("disappearance", DisappearanceController)
application.register("max-length", MaxLengthController)
application.register("copy-to-clipboard", CopyToClipboardController)
application.register("transition", TransitionController)
application.register("dispatcher", DispatcherController)
application.register("prevent-same-path", PreventSamePathController)
application.register("sortable", SortableController)
application.register("broken-image", BrokenImageController)
application.register("auto-save", AutoSaveController)
application.register("form-refresh", FormRefreshController)