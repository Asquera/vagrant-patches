require "vagrant/action/builtin/box_add"

# monkeypatch the vagrant box_add action to fix issue https://github.com/mitchellh/vagrant/issues/4494
module Vagrant
  module Action
    module Builtin
      # This middleware will download a remote box and add it to the
      # given box collection.
      class BoxAdd

        protected

        # Returns the download options for the download.
        #
        # @return [Hash]
        def downloader(url, env, **opts)
          opts[:ui] = true if !opts.has_key?(:ui)

          temp_path = env[:tmp_path].join("box" + Digest::SHA1.hexdigest(url))
          @logger.info("Downloading box: #{url} => #{temp_path}")

          if File.file?(url) || url !~ /^[a-z0-9]+:.*$/i
            @logger.info("URL is a file or protocol not found and assuming file.")
            file_path = File.expand_path(url)
            file_path = Util::Platform.cygwin_windows_path(file_path)
            url = "file:#{file_path}"
          end

          # If the temporary path exists, verify it is not too old. If its
          # too old, delete it first because the data may have changed.
          if temp_path.file?
            delete = false
            if env[:box_clean]
              @logger.info("Cleaning existing temp box file.")
              delete = true
            elsif temp_path.mtime.to_i < (Time.now.to_i - 6 * 60 * 60)
              @logger.info("Existing temp file is too old. Removing.")
              delete = true
            end

            temp_path.unlink if delete
          end

          downloader_options = {}
          downloader_options[:ca_cert] = env[:box_download_ca_cert]
          downloader_options[:ca_path] = env[:box_download_ca_path]
          downloader_options[:continue] = true
          downloader_options[:insecure] = env[:box_download_insecure]
          downloader_options[:client_cert] = env[:box_download_client_cert]
          downloader_options[:headers] = ["Accept: application/json"] if opts[:json]
          downloader_options[:ui] = env[:ui] if opts[:ui]

          Util::Downloader.new(url, temp_path, downloader_options)
        end

      end
    end
  end
end
