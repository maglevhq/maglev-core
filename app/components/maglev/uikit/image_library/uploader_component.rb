class Maglev::Uikit::ImageLibrary::UploaderComponent < Maglev::Uikit::BaseComponent
  attr_reader :create_path, :maxsize

  def initialize(create_path:, maxsize: 2048144)
    @create_path = create_path
    @maxsize = maxsize
  end
  
  def success_message
    t('maglev.editor.image_library.uploader.upload_button.success')
  end

  def error_message
    t('maglev.editor.image_library.uploader.upload_button.fail')
  end

  def too_big_error_message
    t('maglev.editor.image_library.uploader.wrong_files', limit: number_to_human_size(maxsize))
  end
end