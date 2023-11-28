<template>
  <div>
    <uikit-submit-button
      type="button"
      class="rounded-sm text-white py-2 px-4"
      defaultColorClass="bg-editor-primary"
      :labels="$t('imageLibrary.uploader.uploadButton')"
      :buttonState="uploadingState"
      @click="openFileDialog"
    />

    <input
      type="file"
      ref="input"
      accept="image/*"
      :multiple="multiple"
      @change="addFiles"
      class="hidden"
    />
  </div>
</template>

<script>
export default {
  name: 'ImageLibraryUploader',
  props: {
    maxsize: { type: Number, default: 2048144 },
    multiple: { type: Boolean, default: false },
  },
  data() {
    return { uploadingState: 'default' }
  },
  methods: {
    openFileDialog() {
      this.$refs.input.click()
    },
    addFiles() {
      const allowedFiles = this.checkFiles()
      if (allowedFiles) {
        this.uploadingState = 'inProgress'
        Promise.all(
          allowedFiles.map((file) => this.services.image.create({ file })),
        )
          .then(() => {
            this.uploadingState = 'success'
            this.$emit('uploaded')
          })
          .catch((error) => {
            this.uploadingState = 'fail'
            console.log(
              '[Maglev] Uploader failed. Check your server logs',
              error,
            )
          })
      } else {
        alert(
          this.$t('imageLibrary.uploader.wrongFiles', {
            limit: this.$options.filters.numberToHumanSize(this.maxsize),
          }),
        )
      }
    },
    checkFiles() {
      let allowedFiles = []
      const files = this.$refs.input.files
      for (var i = 0; i < files.length; i++) {
        const file = files[i]
        if (file && file.size < this.maxsize) {
          allowedFiles.push(file)
        } else return false
      }
      return allowedFiles
    },
  },
}
</script>
