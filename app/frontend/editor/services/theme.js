export const buildCategories = (theme) => {
  return theme.sectionCategories.map((category) => ({
    label: category.label,
    children: theme.sections
      .filter((section) => section.category == category.id)
      .sort((a, b) => a.name.localeCompare(b.name)),
  }))
}

export const buildLayoutOptions = (theme) => {
  return theme.layouts.map((layout) => ({
    value: layout.id,
    label: layout.label
  }))
}