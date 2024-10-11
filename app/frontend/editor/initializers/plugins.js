const modules = import.meta.glob('@/plugins/*.js')

for (const path in modules) {
  modules[path]()
}
