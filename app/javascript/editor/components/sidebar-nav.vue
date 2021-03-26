<template>
  <nav class="w-16 flex flex-col justify-between">
    <div class="flex justify-center h-full w-full animate-pulse" v-if="!currentPage">
      <div class="w-6 bg-gray-200 rounded h-48 my-6"></div>
    </div>
    <ol class="divide-y divide-gray-300 px-4" v-else>
      <li class="py-6">
        <router-link :to="{ name: 'listSections' }" class="flex justify-center">
          <icon name="add-box-line" size="1.5rem" />
        </router-link>
      </li>
      <li class="py-6">
        <a href="#" class="flex justify-center">
          <icon name="image-line" size="1.5rem" />
        </a>
      </li>
      <li class="py-6">
        <router-link :to="{ name: 'home' }" class="flex justify-center">
          H
        </router-link>
      </li>
      <li class="py-6">
        <router-link :to="{ name: 'test', params: { pageId: currentPage.path } }" class="flex justify-center">
          T
        </router-link>
      </li>
      <li class="py-6">
        <router-link :to="{ name: 'test2', params: { pageId: currentPage.path } }" class="flex justify-center">
          T2
        </router-link>
      </li>
      <li class="py-6"></li>
    </ol>

    <ol class="divide-y divide-gray-300 px-4">
      <li class="py-6"></li>
      <li class="py-6">
        <a href="#" class="flex justify-center">
          <icon name="logout-box-r-line" size="1.5rem" />
        </a>
      </li>
    </ol>
  </nav>
</template>

<script>
export default {
  name: 'SidebarNav'  
}
</script>