class Maglev::Editor::PagesController < Maglev::Editor::BaseController
  before_action :set_page, only: %i[ edit update destroy ]

  def index
    @pages = services.search_pages.call(q: params[:q], content_locale: content_locale,
                                            default_locale: default_content_locale)
  end

  def edit
  end

  def update
    if @page.update(page_params)      
      render :edit, status: :ok
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    raise 'tODO'
  end

  private

  def set_page
    @page = resources.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :path,
                                 :seo_title, :meta_description,
                                 :og_title, :og_description, :og_image_url,
                                 :visible, :lock_version)
  end

  def resources
    ::Maglev::Page
  end
end