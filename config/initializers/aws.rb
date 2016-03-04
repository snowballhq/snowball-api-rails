AWS.config(
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  sns_endpoint: ENV['AWS_SNS_ENDPOINT']
)
