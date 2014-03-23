module TrakAddy
  require 'rails'

  class Railtie < ::Rails::Railtie
    rake_tasks { load 'tasks/trak_addy.rake' }
  end
end
