require 'rails/generators'

module Ethikdo
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates an initializer file at config/initializers"
      source_root File.expand_path('../templates', __dir__)

      def create_initializer_file
        copy_file "initializer.rb", "config/initializers/ethikdo.rb"
      end
    end
  end
end
