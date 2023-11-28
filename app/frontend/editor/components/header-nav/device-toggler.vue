<template>
  <div class="flex items-center">
    <uikit-icon
      v-for="(icon, index) in icons"
      :key="icon.device"
      :name="icon.name"
      :color="icon.color"
      class="cursor-pointer"
      :class="{ 'mx-2': index === 1 }"
      size="1.5rem"
      @click.native="setDevice(icon.device)"
    />
  </div>
</template>

<script>
export default {
  name: 'DeviceToggler',
  computed: {
    devices() {
      return [
        ['desktop', 'computer'],
        ['tablet', 'tablet'],
        ['mobile', 'smartphone'],
      ]
    },
    icons() {
      return this.devices.map((settings) => ({
        device: settings[0],
        name: `${settings[1]}-line`,
        color:
          settings[0] === this.device ? 'var(--editor-color-primary)' : null,
      }))
    },
  },
}
</script>
