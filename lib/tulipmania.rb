# encoding: utf-8

# stdlibs
require 'json'
require 'digest'
require 'net/http'
require 'set'
require 'pp'


### 3rd party gems
require 'sinatra/base'                         # note: use "modular" sinatra app / service
require 'blockchain-lite/proof_of_work/block'  # note: use proof-of-work block only (for now)


### our own code
require 'tulipmania/version'    ## let version always go first
require 'tulipmania/block'
require 'tulipmania/cache'
require 'tulipmania/transaction'
require 'tulipmania/blockchain'
require 'tulipmania/exchange'
require 'tulipmania/ledger'
require 'tulipmania/wallet'

require 'tulipmania/node'




module Tulipmania

class Service < Sinatra::Base

  def self.banner
    "tulipmania/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] on Sinatra/#{Sinatra::VERSION} (#{ENV['RACK_ENV']})"
  end


## - for now hard-code address e.g. Sepp
NODE = Node.new( address: 'Sepp' )


PUBLIC_FOLDER = "#{Tulipmania.root}/lib/tulipmania/public"
VIEWS_FOLDER  = "#{Tulipmania.root}/lib/tulipmania/views"

puts "[tulipmania] boot - setting public folder to: #{PUBLIC_FOLDER}"
puts "[tulipmania] boot - setting views folder to: #{VIEWS_FOLDER}"

set :public_folder, PUBLIC_FOLDER # set up the static dir (with images/js/css inside)
set :views, VIEWS_FOLDER # set up the views dir

set :static, true # set up static file routing  -- check - still needed?


set connections: []


get '/style.css' do
  scss :style    ## note: converts (pre-processes) style.scss to style.css
end


get '/' do
  @node = NODE
  erb :index
end

post '/send' do
  NODE.on_send( params[:to], params[:amount].to_i )
  settings.connections.each { |out| out << "data: added transaction\n\n" }
  redirect '/'
end


post '/transactions' do
  if NODE.on_add_transaction(
    params[:from],
    params[:to],
    params[:amount].to_i,
    params[:id]
  )
    settings.connections.each { |out| out << "data: added transaction\n\n" }
  end
  redirect '/'
end

post '/mine' do
  NODE.on_mine!
  redirect '/'
end

post '/peers' do
  NODE.on_add_peer( params[:host], params[:port].to_i )
  redirect '/'
end

post '/peers/:index/delete' do
  NODE.on_delete_peer( params[:index].to_i )
  redirect '/'
end



post '/resolve' do
  data = JSON.parse(request.body.read)
  if data['chain'] && NODE.on_resolve( data['chain'] )
    status 202     ### 202 Accepted; see httpstatuses.com/202
    settings.connections.each { |out| out << "data: resolved\n\n" }
  else
    status 200    ### 200 OK
  end
end


get '/events', provides: 'text/event-stream' do
  stream :keep_open do |out|
    settings.connections << out
    out.callback { settings.connections.delete(out) }
  end
end


end # class Service
end # module Tulipmania


# say hello
puts Tulipmania::Service.banner
