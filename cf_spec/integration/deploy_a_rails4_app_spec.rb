$: << 'cf_spec'
require 'cf_spec_helper'
module Machete
  describe 'Rails 4 App' do
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
        focker.vendor_dependencies('./cf_spec/fixtures/rails4_web_app')
        focker.deploy_app('./cf_spec/fixtures/rails4_web_app')
        expect(focker).to have_successfully_deployed_app

        browser.visit('/')
        expect(browser).to have_body('The Kessel Run')
        expect(firewall_log).to_not have_egress_attempts
      end
    end

    context 'in an online environment' do
      before do
        Machete.use_online_environment
      end

      context 'app has dependencies' do
        specify do
          focker.vendor_dependencies('./cf_spec/fixtures/rails4_web_app')
          focker.deploy_app('./cf_spec/fixtures/rails4_web_app')
          expect(focker).to have_successfully_deployed_app

          browser.visit('/')
          expect(browser).to have_body('The Kessel Run')
        end
      end

      context 'app has no dependencies' do
        specify do
          focker.remove_vendored_dependencies('./cf_spec/fixtures/rails4_web_app')
          focker.deploy_app('./cf_spec/fixtures/rails4_web_app')
          expect(focker).to have_successfully_deployed_app

          browser.visit('/')
          expect(browser).to have_body('The Kessel Run')
        end
      end
    end
  end
end
