PP_TRANSACTIONS_BY_CHANNEL_TOKEN = ENV['PP_TRANSACTIONS_BY_CHANNEL_TOKEN']

Rails.logger.info('***No Bearer token for Performance Platform transactions by channel') if PP_TRANSACTIONS_BY_CHANNEL_TOKEN.nil?
