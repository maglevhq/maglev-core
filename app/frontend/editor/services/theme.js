import { isBlank } from '@/misc/utils.js'

export const buildLayoutOptions = (theme) => {
  return theme.layouts.map((layout) => ({
    value: layout.id,
    label: layout.label
  }))
}

export const buildCategories = ({ theme, layoutId, layoutGroupId, insertedSectionTypes }) => {
  const layoutGroup = findLayoutGroup({ theme , layoutId, layoutGroupId })
  return theme.sectionCategories
    .map(category => buildCategory({ category, layoutGroup, sections: theme.sections, insertedSectionTypes }))
    .filter((category) => category !== null)
}

const findLayoutGroup = ({ theme, layoutId, layoutGroupId }) => {
  const layout = theme.layouts.find(layout => layout.id === layoutId)
  return layout.groups.find(group => group.id === layoutGroupId)
}

const buildCategory = ({ category, sections, layoutGroup, insertedSectionTypes }) => {
  const filterSections = sections.filter(section => filterSection({ section, categoryId: category.Id, layoutGroup, insertedSectionTypes }))

  if (filterSections.length === 0) return null

  return {
    label: category.label,
    children: filterSections.sort((a, b) => a.name.localeCompare(b.name))
  }
}

const filterSection = ({ section, categoryId, layoutGroup, insertedSectionTypes }) => {
  const recoverable = isBlank(layoutGroup.recoverable) ? [] : layoutGroup.recoverable
  const accepts = isBlank(layoutGroup.accept) ? ['*'] : layoutGroup.accept
  
  // reject if the section is singleton in the context of the layoutGroup AND
  // if there is another same section type in the group.
  if (recoverable.includes(section.id) && insertedSectionTypes.includes(section.id)) return false

  // Wildcard: accept all sections
  if (accepts.includes("*")) return true

  const sectionId = section.id
  const scopedId = `${section.category}/${section.id}`

  return accepts.includes(sectionId) || accepts.includes(scopedId) || accepts.includes(`${categoryId}/*`)
}