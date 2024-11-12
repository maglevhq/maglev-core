# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Plugins do
  let(:plugins) { described_class.new }
  let(:engine_path) { File.join(File.dirname(__FILE__), '../../..') }
  let(:plugins_path) { File.join(engine_path, 'plugins') }
  let(:fake_root_path) { File.dirname(__FILE__) }

  describe '#register' do
    subject { plugins.register(id: 'foo', root_path: fake_root_path) }

    it 'adds a plugin into the list of plugins' do
      expect { subject }.to change { plugins.size }.from(0).to(1)
    end

    context 'a plugin with the same name has been registerd' do
      it 'raises an PluginAlreadyRegisteredError error' do
        subject
        expect do
          plugins.register(id: 'foo', root_path: fake_root_path)
        end.to raise_error(Maglev::Plugins::PluginAlreadyRegisteredError)
      end
    end
  end

  describe '#empty?' do
    subject { plugins.empty? }

    it { is_expected.to eq true }

    context 'a plugin has been registered' do
      before { plugins.register(id: 'foo', root_path: fake_root_path) }

      it { is_expected.to eq false }
    end
  end

  describe '#install!' do
    before do
      plugins.register(id: 'foo', root_path: Rails.root.join('packages/foo'))
      plugins.register(id: 'bar', root_path: Rails.root.join('packages/bar'))
    end

    subject { plugins.install! }

    after { plugins.uninstall! }

    it 'installs all the plugins' do
      subject
      expect(File.symlink?(File.join(plugins_path, 'foo'))).to eq true
      expect(File.symlink?(File.join(plugins_path, 'bar'))).to eq true
      expect(File.exist?(File.join(engine_path, 'app/frontend/editor/plugins/foo.js'))).to eq true
      expect(File.exist?(File.join(engine_path, 'app/frontend/editor/plugins/bar.js'))).to eq true
    end
  end

  describe '#single_uninstall!' do
    before do
      plugins.register(id: 'foo', root_path: Rails.root.join('packages/foo'))
      plugins.install!
    end

    let(:plugin_id) { 'foo' }

    subject { plugins.single_uninstall!(plugin_id) }

    it 'uninstall the plugin' do
      expect { subject }.to change { File.symlink?(File.join(plugins_path, 'foo')) }.from(true).to(false)
    end

    context 'the plugin has never been registered' do
      let(:plugin_id) { 'bar' }

      after { plugins.uninstall! }

      it 'raises an UnknownPluginError error' do
        expect { subject }.to raise_error(Maglev::Plugins::UnknownPluginError)
      end
    end
  end
end
