Gem::Specification.new do |s|
  s.name = 'sps_messenger_pusher'
  s.version = '0.1.0'
  s.summary = 'Publishes SPS messages at regular intervals primarily for viewing by a human.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/sps_messenger_pusher.rb']
  s.add_runtime_dependency('sps-sub', '~> 0.3', '>=0.3.6')
  s.add_runtime_dependency('rss_to_dynarex', '~> 0.1', '>=0.1.7')
  s.signing_key = '../privatekeys/sps_messenger_pusher.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/sps_messenger_pusher'
end
