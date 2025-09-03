class Maglev::Inputs::InputBaseComponent < ViewComponent::Base
  attr_reader :setting, :value, :scope

  def initialize(setting:, value:, scope:)
    @setting = setting
    @value = value
    @scope = scope
  end

  def input_name
    "#{scope}[#{setting.id}]"
  end
end