export const buildCategories = theme => {
  return theme.sectionCategories.map(category => ({
    name: category.name,
    children: theme.sections
      .filter(section => section.category == category.id)
      .sort((a, b) => a.name.localeCompare(b.name)),
  }))
}
