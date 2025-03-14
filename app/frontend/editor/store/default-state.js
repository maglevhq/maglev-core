export default {
  device: 'desktop',
  previewReady: false,
  site: null,
  style: null,
  locale: null,
  theme: null,
  page: null,
  section: null,
  sectionDefinition: null,
  hoveredSection: null,
  sectionBlock: null,
  sectionBlockDefinition: null,
  sectionsContent: [], // array of layoutGroups
  layoutGroups: {}, // each layoutGroup has a list of sections
  sections: {},
  sectionBlocks: {},
  editorSettings: {},
  touchedSections: [],
  ui: {
    saveButtonState: 'default',
    publishButtonState: {
      status: null,
      label: null,
    },
    openErrorModal: false,
    errorModalType: null,
  },
}
