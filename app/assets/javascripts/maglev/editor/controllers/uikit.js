import { application } from  "maglev-controllers/application"

import DropdownController from "uikit-controllers/dropdown_component/dropdown_controller"
import TabsController from "uikit-controllers/tabs_component/tabs_controller"
import DeviceTogglerController from "uikit-controllers/device_toggler_component/device_toggler_controller"
import ModalController from "uikit-controllers/modal_component/modal_controller"
import SearchFormController from "uikit-controllers/form/search_form_controller"
import ImageFieldController from "uikit-controllers/form/image_field_controller"
import ImageLibraryUploaderController from "uikit-controllers/image_library/uploader_controller"
import CollapsibleController from "uikit-controllers/collapsible/collapsible_controller"
import PageLayoutController from "uikit-controllers/page_layout_component/page_layout_controller"
import SectionToolbarController from "uikit-controllers/section_toolbar/section_toolbar_controller"

application.register("uikit-dropdown", DropdownController)
application.register("uikit-tabs", TabsController)
application.register("uikit-device-toggler", DeviceTogglerController)
application.register("uikit-modal", ModalController)
application.register("uikit-search-form", SearchFormController)
application.register("uikit-image-library-uploader", ImageLibraryUploaderController)
application.register("uikit-form-image-field", ImageFieldController)
application.register("uikit-collapsible", CollapsibleController)
application.register("uikit-page-layout", PageLayoutController)
application.register("uikit-section-toolbar", SectionToolbarController)