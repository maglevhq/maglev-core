module Maglev::Editor::SectionBlocksHelper
  def delete_section_block_button(section, section_block, maglev_editing_route_context)
    button_to(
      editor_section_block_path(section, section_block, **maglev_editing_route_context), 
      method: :delete, 
      class: maglev_icon_button_classes, 
      data: {  turbo_confirm: t('maglev.editor.section_blocks.index.confirm_delete') }, 
      form: { 
        data: {
          action: 'turbo:submit-end->editor-preview-notification-center#deleteSectionBlock',
          'editor-preview-notification-center-section-id-param': section.id,
          'editor-preview-notification-center-section-block-id-param': section_block.id
        }
      }) do
      render Maglev::Uikit::IconComponent.new(name: "delete_bin", size: "1.15rem")
    end 
  end

  def add_section_block_button(section, block_definitions)
    if block_definitions.blank?
      ''
    elsif block_definitions.one?
      add_section_block_no_dropdown_button(section, block_definitions.first.type)
    else
      add_section_block_dropdown_button(section, block_definitions)
    end
  end

  def add_section_block_no_dropdown_button(section, block_type)
    button_to(
      t('maglev.editor.section_blocks.index.add_button'),
      editor_section_blocks_path(section, block_type: block_type, **maglev_editing_route_context), 
      class: maglev_button_classes(size: :big),
      method: :post,
      name: 'add_section_block',
      form: {
        data: { 
          turbo_frame: '_top',
          action: 'turbo:submit-end->editor-preview-notification-center#addSectionBlock',
          'editor-preview-notification-center-section-id-param': section.id,
        } 
      }
    )
  end

  def add_section_block_dropdown_button(section, block_definitions)
    render Maglev::Uikit::DropdownComponent.new do |dropdown|
      dropdown.with_trigger do
        button_tag(t('maglev.editor.section_blocks.index.add_button'), 
          type: 'button',
          class: maglev_button_classes(size: :big),
          data: {
            action: 'click->uikit-dropdown#toggle',
            'uikit-dropdown-target': 'button'
          })
      end
              
      content_tag(:div, class: 'p-4 min-w-64') do
        render 'maglev/editor/section_blocks/new', blocks: block_definitions, parent_id: nil
      end
    end
  end

  def add_child_section_block_button(section, section_block)
    block_definitions = section.child_block_definitions_of(section_block.id)
    if block_definitions.one?      
      add_child_section_block_no_dropdown_button(section, section_block.id, block_definitions.first.type)
    elsif block_definitions.any?
      add_child_section_block_dropdown_button(section, section_block.id, block_definitions)
    end
  end

  def add_child_section_block_no_dropdown_button(section, parent_id, block_type)
    button_to(
      editor_section_blocks_path(section, block_type: block_type, parent_id: parent_id, **maglev_editing_route_context), 
      class: maglev_icon_button_classes,
        method: :post,
        name: 'add_child_section_block',
        form: {
          data: { 
            turbo_frame: '_top',
            action: 'turbo:submit-end->editor-preview-notification-center#addSectionBlock',
            'editor-preview-notification-center-section-id-param': section.id,
          } 
        }
    ) do
      render Maglev::Uikit::IconComponent.new(name: 'add', size: "1.15rem")
    end
  end

  def add_child_section_block_dropdown_button(section, parent_id, block_definitions)
    render Maglev::Uikit::DropdownComponent.new do |dropdown|
      dropdown.with_trigger do
        button_tag(
          type: 'button',
          class: maglev_icon_button_classes,
          data: {
            action: 'click->uikit-dropdown#toggle',
            'uikit-dropdown-target': 'button'
          }) do
            render Maglev::Uikit::IconComponent.new(name: 'add', size: "1.15rem")
        end
      end
              
      content_tag(:div, class: 'p-4 min-w-64') do
        render 'maglev/editor/section_blocks/new', blocks: block_definitions, parent_id: parent_id
      end
    end
  end
end