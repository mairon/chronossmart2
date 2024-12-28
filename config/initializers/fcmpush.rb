Fcmpush.configure do |config|
  ## for message push
  # firebase web console => project settings => service account => firebase admin sdk => generate new private key

  # pass string of path to credential file to config.json_key_io
  config.json_key_io = "#{Rails.root}/lib/crescer-1498a-firebase-adminsdk-1awii-c4952350b2.json"
  # Or content of json key file wrapped with StringIO
  # config.json_key_io = StringIO.new('{ ... }')

  # Or set environment variables
  # ENV['GOOGLE_ACCOUNT_TYPE'] = 'service_account'
  # ENV['GOOGLE_CLIENT_ID'] = '000000000000000000000'
  # ENV['GOOGLE_CLIENT_EMAIL'] = 'xxxx@xxxx.iam.gserviceaccount.com'
  # ENV['GOOGLE_PRIVATE_KEY'] = '-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n\'

  ## for topic subscribe/unsubscribe because they use regacy auth
  # firebase web console => project settings => cloud messaging => Project credentials => Server key
  # @deprecated: This attribute will be removed next version.
  config.server_key = 'AIzaSyCLNGWvwByssCFAC4NTODV-AjJr1J6EmKM'
  # Or set environment variables
  # @deprecated: This attribute will be removed next version.
  # ENV['FCM_SERVER_KEY'] = 'your firebase server key'

  # Proxy ENV variables are considered by default if set by net/http, but you can explicitly define your proxy host here
  # user and password are optional
  # config.proxy = { uri: "http://proxy.host:3128", user: nil, password: nil }
  # explicitly disable using proxy, even ignore environment variables if set
  # config.proxy = false

  # HTTP connection open and read timeouts (in seconds) are set for all client requests.
  # If unset, the default values for Net::HTTP::Persistent are used (currently 60 seconds).
  # config.open_timeout = 30
  # config.read_timeout = 15
end