class Maglev::Uikit::ModalComponent < Maglev::Uikit::BaseComponent
  renders_one :title
  renders_one :footer

  attr_reader :id, :open, :focus
  
  def initialize(id:, open: false, focus: true, size: 'default')
    @id = id
    @open = open
    @focus = focus
    @size = size
  end

  def dialog_classes
    class_variants(
      base: 'relative transform overflow-y-visible rounded-lg bg-white px-4 pb-4 pt-5 text-left shadow-xl transition-all sm:my-8 sm:p-6 hidden',
      variants: {
        size: {
          small: 'w-full sm:max-w-xl sm:min-w-96 sm:w-auto',
        }
      },
      defaults: {
        size: :default
      }
    ).render(size: @size)
  end
end