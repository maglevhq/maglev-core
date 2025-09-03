class Maglev::Content::SettingContent
  include ActiveModel::Model
  extend ActiveModel::Naming

  attr_accessor :id, :type, :value

  class AssociationProxy
    def initialize(raw_settings)
      @settings = raw_settings.map { |raw_setting| Maglev::Content::SettingContent.new(raw_setting) }
    end

    def [](id)
      @settings.find { |s| s.id == id }
    end

    def value_of(id)
      self[id]&.value
    end

    # def respond_to_missing?(method_name, include_private = false)
    #   @settings.map(&:id).include?(method_name.to_s) || super
    # end

    # def method_missing(method_name, *args, &block)
    #   @settings.find { |s| s.id == method_name.to_s }&.value
    # end
  end
end