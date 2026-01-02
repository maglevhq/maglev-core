# frozen_string_literal: true

module Maglev
  module Editor
    class MirroredSectionsController < Maglev::Editor::BaseController
      before_action :ensure_turbo_frame_request, only: [:new]

      def new
        @mirrored_section = Maglev::Content::EditorMirroredSection.new(position: params[:position] || -1)
        render layout: false
      end

      def create
        @mirrored_section = Maglev::Content::EditorMirroredSection.new(mirrored_section_params)        

        refresh_form and return if params[:refresh] == '1' || !@mirrored_section.valid?
          
        @section = create_section

        notify_added_section        
      end  
      
      def show
        @section = current_maglev_page_content.find_section(params[:id])
      end

      def destroy
        services.unlink_mirrored_section.call(store: sections_store, section_id: params[:id])
        redirect_to edit_editor_section_path(params[:id], maglev_editing_route_context), notice: flash_t(:success), status: :see_other
      end

      private

      def mirrored_section_params
        params.require(:mirrored_section).permit(:page_id, :section_id, :position)
      end
      
      def sections_store
        @sections_store ||= services.fetch_sections_store.call(page: current_maglev_page, handle: params[:store_id])
      end      

      def create_section
        services.add_section.call(
          store: sections_store,
          layout_id: current_maglev_page.layout_id,
          section_type: @mirrored_section.section_type,
          mirror_of: @mirrored_section.to_mirror_of,
          position: params[:position].to_i
        )        
      end

      def notify_added_section
        flash[:notice] = flash_t(:success)

        # required by the preview notification center to notify the client about the newly added section
        headers['X-Layout-Store-Id'] = params[:store_id]
        headers['X-Section-Id'] = @section[:id]
        headers['X-Section-Position'] = sections_store.position_of_section(@section[:id])
      end

      def refresh_form
        @page = maglev_page_resources.find_by(id: @mirrored_section.page_id)
        if @page.nil? || @page.id == current_maglev_page.id
          reset_form
        else
          fetch_sections
        end
        render :new, status: :unprocessable_content, layout: false
      end

      def fetch_sections
        # we want to display the sections grouped by their layout store (header, main, ...etc)
        @sections = services.get_page_section_names.call(
          page: @page, 
          available_for_mirroring: true, 
          already_mirrored_section_ids: current_maglev_page_content.mirrored_section_ids
        )
      end

      def reset_form
        @page = nil
        @mirrored_section.page_id = nil
        @mirrored_section.section_id = nil
      end  
    end
  end
end
