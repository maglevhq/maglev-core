import { application } from  "maglev-controllers/application"
import DropdownController from "uikit-controllers/maglev/uikit/dropdown_component/dropdown_controller"
import TabsController from "uikit-controllers/maglev/uikit/tabs_component/tabs_controller"
import DeviceTogglerController from "uikit-controllers/maglev/uikit/device_toggler_component/device_toggler_controller"
import ModalController from "uikit-controllers/maglev/uikit/modal_component/modal_controller"
import SearchFormController from "uikit-controllers/maglev/uikit/form/search_form_controller"
import ImageLibraryUploaderController from "uikit-controllers/maglev/uikit/image_library/uploader_controller"

import DisappearanceController from "maglev-controllers/disappearance_controller"
import MaxLengthController from "maglev-controllers/max_length_controller"
import CopyToClipboardController from "maglev-controllers/copy_to_clipboard_controller"
import TransitionController from "maglev-controllers/transition_controller"

application.register("uikit-dropdown", DropdownController)
application.register("uikit-tabs", TabsController)
application.register("uikit-device-toggler", DeviceTogglerController)
application.register("uikit-modal", ModalController)
application.register("uikit-search-form", SearchFormController)
application.register("uikit-image-library-uploader", ImageLibraryUploaderController)

application.register("disappearance", DisappearanceController)
application.register("max-length", MaxLengthController)
application.register("copy-to-clipboard", CopyToClipboardController)
application.register("transition", TransitionController)