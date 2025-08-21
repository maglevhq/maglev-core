class Maglev::Uikit::PageActionsDropdownComponent < Maglev::Uikit::BaseComponent
  attr_reader :paths, :live_url, :without_actions, :icon_direction

  def initialize(paths:, live_url:, without_actions: [], icon_direction: :vertical)
    @paths = paths
    @live_url = live_url  
    @without_actions = without_actions
    @icon_direction = icon_direction
  end

  def allow?(action)
    !without_actions.include?(action)
  end

  def icon_name
    icon_direction == :vertical ? 'more_2' : 'more'
  end
end