require 'hoe'
require './lib/tulipmania/version.rb'

Hoe.spec 'tulipmania' do

  self.version = Tulipmania::VERSION

  self.summary = 'tulipmania - tulips on the blockchain; learn by example from the real world (anno 1637) - buy! sell! hodl! enjoy the beauty of admiral of admirals, semper augustus, and more; run your own hyper ledger tulip exchange nodes on the blockchain peer-to-peer over HTTP; revolutionize the world one block at a time'
  self.description = summary

  self.urls    = ['https://github.com/openblockchains/tulipmania']

  self.author  = 'Gerald Bauer'
  self.email   = 'ruby-talk@ruby-lang.org'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'History.md'

  self.extra_deps = [
    ['sinatra', '>=2.0'],
    ['sass'],   ## used for css style preprocessing (scss)
    ['blockchain-lite', '>=1.3.1'],
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 2.3'
  }

end
