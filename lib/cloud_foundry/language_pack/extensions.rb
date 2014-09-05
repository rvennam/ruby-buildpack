DEPENDENCIES_PATH = File.expand_path("../../dependencies", File.expand_path($0))
DEPENDENCIES_TRANSLATION_REGEX = /[:\/]/
DEPENDENCIES_TRANSLATION_DELIMITER = '_'

require 'cloud_foundry/language_pack/fetcher'
require 'cloud_foundry/language_pack/ruby'
require 'cloud_foundry/language_pack/helpers/plugins_installer'

module LanguagePack
  module Extensions
    def self.translate(host_url, original_filename)
      if original_filename.include?("ruby-2.1")
        prefix = "http://build-ruby.10.244.0.34.xip.io".to_s.gsub(DEPENDENCIES_TRANSLATION_REGEX, DEPENDENCIES_TRANSLATION_DELIMITER)
      else
        prefix = host_url.to_s.gsub(DEPENDENCIES_TRANSLATION_REGEX, DEPENDENCIES_TRANSLATION_DELIMITER)
      end

      "#{prefix}#{delimiter_for(prefix)}#{original_filename}"
    end

    def self.delimiter_for(prefix)
      (prefix.end_with? '_') ? '' : DEPENDENCIES_TRANSLATION_DELIMITER
    end
  end
end
