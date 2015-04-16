require 'rubygems'
require 'rack'
require 'hello_world'

# Reloader middleware je nesto kao live reload. Osvježava sve required fileove bez restarta servera.
use Rack::Reloader, 0
# use Rack::Auth::Basic do |username, password|
#   username == "vlado" && password == "secret"
# end
# https://github.com/rack/rack-contrib

run HelloWorld.new
# run Proc.new { |env| [200, { "Content-Type" => "text/html" }, ["Hello world from Proc!"]] }
# run Proc.new { |env| [200, { "Content-Type" => "text/html" }, env.inspect] }

# Under the hood, rackup converts your config script to an instance of Rack::Builder.
# http://m.onkey.org/ruby-on-rack-2-the-builder