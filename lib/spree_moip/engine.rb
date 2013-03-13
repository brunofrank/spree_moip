module SpreeMoip
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_moip'

    config.autoload_paths += %W(#{config.root}/lib)

    # Enabling assets precompiling under rails 3.1
    initializer :assets do |config|
      Rails.application.config.assets.paths << File.join(File.dirname(__FILE__), 'app', 'assets', 'javascripts', 'admin')
      Rails.application.config.assets.paths << File.join(File.dirname(__FILE__), 'app', 'assets', 'javascripts', 'store')      
      Rails.application.config.assets.paths << File.join(File.dirname(__FILE__), 'app', 'assets', 'stylesheets', 'admin')
      Rails.application.config.assets.paths << File.join(File.dirname(__FILE__), 'app', 'assets', 'stylesheets', 'store')      

      Rails.application.config.assets.precompile += %w( *.css *.js )
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
    
    initializer 'spree.register.payment_methods' do |app|
      app.config.spree.payment_methods <<  Spree::PaymentMethod::Moip
      app.config.spree.payment_methods
    end
  end
end
