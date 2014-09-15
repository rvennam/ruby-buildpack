$: << 'cf_spec'
require 'cf_spec_helper'

module Machete
  describe 'Rack App' do
    let(:browser) { Browser.new }
    let(:firewall_log) { FirewallLog.new }
    let(:focker) { Focker.new }

    before(:all) do
      Focker.stop_staging
      sleep 1
    end

    context 'in an offline environment' do
      before do
        Machete.use_offline_environment
      end

      specify do
        focker.vendor_dependencies('./cf_spec/fixtures/sinatra_web_app')
        focker.deploy_app('./cf_spec/fixtures/sinatra_web_app')
        expect(focker).to have_successfully_deployed_app

        browser.visit('/')

        expect(firewall_log).to_not have_egress_attempts
      end
    end

    context 'in an online environment' do
      before do
        Machete.use_online_environment
      end

      specify do
        focker.remove_vendored_dependencies('./cf_spec/fixtures/sinatra_web_app')
        focker.deploy_app('./cf_spec/fixtures/sinatra_web_app')
        expect(focker).to have_successfully_deployed_app

        browser.visit('/')
        expect(browser).to have_body('Hello world!')
      end
    end
  end
end
