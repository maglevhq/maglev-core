export const encodeToTree = (blocks, parentId) => {
  return blocks
    .filter((block) => block.parentId === parentId)
    .map((block) => ({
      sectionBlock: { ...block },
      children: encodeToTree(blocks, block.id),
    }))
}

export const decodeTree = (tree, parentId) => {
  return tree
    .map((treeNode) => {
      return [].concat(
        { ...treeNode.sectionBlock, parentId },
        decodeTree(treeNode.children, treeNode.sectionBlock.id),
      )
    })
    .flat()
}
