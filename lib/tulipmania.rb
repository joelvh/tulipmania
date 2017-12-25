# encoding: utf-8

# stdlibs
require 'json'
require 'digest'
require 'net/http'
require 'set'
require 'pp'


### 3rd party gems
require 'sinatra/base'                         # note: use "modular" sinatra app / service

require 'merkletree'
require 'blockchain-lite/proof_of_work/block'  # note: use proof-of-work block only (for now)


### our own code
require 'tulipmania/version'    ## let version always go first
require 'tulipmania/block'
require 'tulipmania/cache'
require 'tulipmania/transaction'
require 'tulipmania/blockchain'
require 'tulipmania/pool'
require 'tulipmania/exchange'
require 'tulipmania/ledger'
require 'tulipmania/wallet'

require 'tulipmania/node'
require 'tulipmania/service'




module Tulipmania

  class Configuration
     ## user/node settings
     attr_accessor :address   ## single wallet address (for now "clear" name e.g.Sepp, Franz, etc.)

     WALLET_ADDRESSES = %w[Alice Bob Max Franz Maria Ferdl Lisi Adam Eva]

     ## system/blockchain settings
     attr_accessor :coinbase
     attr_accessor :mining_reward


     def initialize
       ## try default setup via ENV variables
       ## pick "random" address if nil (none passed in)
       @address = ENV[ 'TULIPMANIA_NAME'] || WALLET_ADDRESSES[rand( WALLET_ADDRESSES.size )]

       @coinbase      = 'COINBASE'   ## use a different name - why? why not?
       @mining_reward = 5
     end
  end # class Configuration


  ## lets you use
  ##   Tulipmania.configure do |config|
  ##      config.address = 'Bloom & Blossom'
  ##   end

  def self.configure
    yield( config )
  end

  def self.config
    @config ||= Configuration.new
  end


end # module Tulipmania



# say hello
puts Tulipmania::Service.banner
