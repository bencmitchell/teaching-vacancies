Rails.application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb.

  # Configure the domains permitted to access coordinates API
  config.allowed_cors_origin = proc { "https://#{DOMAIN}" }

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Attempt to read encrypted secrets from `config/secrets.yml.enc`.
  # Requires an encryption key in `ENV["RAILS_MASTER_KEY"]` or
  # `config/secrets.yml.key`.
  # config.read_encrypted_secrets = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # `config.assets.precompile` and `config.assets.version` have moved to
  # config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'

  # Force all access to the app over SSL, use Strict-Transport-Security,
  # and use secure cookies.
  config.force_ssl = true
  config.ssl_options = { redirect: { exclude: ->(request) { request.path.include?("check") } } }

  config.cache_store = :redis_cache_store, { url: config.redis_cache_url, pool_size: ENV.fetch("RAILS_MAX_THREADS", 5) }

  # Use a real queuing backend for Active Job
  # (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "teaching-vacancies_#{Rails.env}"
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to
  # raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Logging
  config.log_level = :info
  config.log_tags = [:request_id] # Prepend all log lines with the following tags.
  config.logger = ActiveSupport::Logger.new($stdout)
  config.active_record.logger = nil # Don't log SQL in production

  # Use Lograge for cleaner logging
  config.lograge.enabled = true
  config.lograge.formatter = ColourLogFormatter.new
  config.lograge.ignore_actions = ["ApplicationController#check"]
  config.lograge.logger = ActiveSupport::Logger.new($stdout)

  # Include params in logs: https://github.com/roidrage/lograge#what-it-doesnt-do
  config.lograge.custom_options = lambda do |event|
    exceptions = %w[controller action format id]
    {
      ip: event.payload[:remote_ip],
      session_id: event.payload[:session_id],
      params: event.payload[:params].except(*exceptions),
    }
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.action_dispatch.trusted_proxies = [
    ActionDispatch::RemoteIp::TRUSTED_PROXIES,
    AWSIpRanges.cloudfront_ips.map { |proxy| IPAddr.new(proxy) },
  ].flatten

  # Ensure browsers don't cache
  config.action_dispatch.default_headers["Cache-Control"] = "no-cache, no-store"

  config.active_storage.service = :amazon
end
