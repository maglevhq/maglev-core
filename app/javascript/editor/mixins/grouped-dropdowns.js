export default {
  data() {
    return { currentDropdown: null }
  },
  methods: {
    onDropdownToggle(dropdown) {
      if (
        dropdown.open &&
        this.currentDropdown &&
        dropdown !== this.currentDropdown
      ) {
        this.currentDropdown.close()
      }
      this.currentDropdown = dropdown
    },
  },
}
