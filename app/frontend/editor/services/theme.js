import { isBlank } from '@/misc/utils.js'

export const buildLayoutOptions = (theme) => {
  return theme.layouts.map((layout) => ({
    value: layout.id,
    label: layout.label
  }))
}

export const buildCategories = ({ theme, layoutId, layoutGroupId }) => {
  const layoutGroup = findLayoutGroup({ theme , layoutId, layoutGroupId })
  return theme.sectionCategories
    .map(category => buildCategory({ category, layoutGroup, sections: theme.sections }))
    .filter((category) => category !== null)
}

const findLayoutGroup = ({ theme, layoutId, layoutGroupId }) => {
  const layout = theme.layouts.find(layout => layout.id === layoutId)
  return layout.groups.find(group => group.id === layoutGroupId)
}

const buildCategory = ({ category, sections, layoutGroup }) => {
  const filterSections = sections.filter(section => filterSection({ section, categoryId: category.Id, layoutGroup }))

  if (filterSections.length === 0) return null

  return {
    label: category.label,
    children: filterSections.sort((a, b) => a.name.localeCompare(b.name))
  }
}

const filterSection = ({ section, categoryId, layoutGroup }) => {
  const accepts = isBlank(layoutGroup.accept) ? ['*'] : layoutGroup.accept

  // Wildcard: accept all sections
  if (accepts.includes("*")) return true

  const sectionId = section.id
  const scopedId = `${section.category}/${section.id}`

  return accepts.includes(sectionId) || accepts.includes(scopedId) || accepts.includes(`${categoryId}/*`)
}