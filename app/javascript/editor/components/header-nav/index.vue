<template>
  <nav class="h-full w-full">
    <div class="flex items-center justify-between h-full w-full animate-pulse" v-if="!currentPage">
      <div class="h-6 bg-gray-200 rounded w-1/4 mx-6"></div>
      <div class="h-6 bg-gray-200 rounded w-1/4 mx-6"></div>
    </div>
    <div class="flex justify-between h-full w-full" v-else>
      <ol class="flex divide-x divide-gray-300 py-4">
        <li class="px-6 flex flex-row items-center">
          <span>{{ $t('headerNav.pages') }}</span>
          <a href="#" class="flex items-center ml-4">
            <icon name="home-4-line" size="1.25rem" />
            <span class="ml-2">{{ currentPage.title }}</span>
          </a>
        </li>
        <li class="px-6 flex">
          <a href="#" class="flex items-center">
            <icon name="settings-4-line" size="1.25rem" />
            <span class="ml-2">{{ $t('headerNav.pageSettings') }}</span>
          </a>
        </li>
      </ol>

      <div class="flex">
        <ol class="flex divide-x divide-gray-300 py-4">
          <li class="px-6 flex">
            <device-toggler />
          </li>
          <li class="px-6 flex items-center">
            <a :href="currentPage.previewUrl" target="_blank">{{ $t('headerNav.previewSite') }}</a>
          </li>      
        </ol>

        <div>
          <save-button />
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
import DeviceToggler from './device-toggler'
import SaveButton from './save-button'

export default {
  name: 'HeaderNav',
  components: { DeviceToggler, SaveButton }
}
</script>