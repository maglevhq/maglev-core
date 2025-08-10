class Maglev::Uikit::IconComponentPreview < ViewComponent::Preview
  def default
    render_with_template(locals: {
      list: icon_list,
    })
  end

  private

  def icon_list
    [
      'ri_stack_line',
      'ri_file_copy_line',
      'logout_box_r_line',
      'home_4_line',
      'ri_file_line',
    ]
  end
end