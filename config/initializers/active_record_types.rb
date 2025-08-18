require_relative '../../app/types/maglev/locales_type'

ActiveRecord::Type.register(:maglev_locales, Maglev::LocalesType)