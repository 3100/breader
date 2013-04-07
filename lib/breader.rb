# -*- coding: utf-8 -*-

module BReader
  require 'slim'
  require 'zbar'
  require 'sinatra/base'

  class App < Sinatra::Base
    configure do
    end

    get '/' do
      slim :uploader
    end

    post '/upload' do
      data = request.body.read
      filepath = "sample.jpg"
      begin
        File.open(filepath, "w") do |f|
          f.write(data)
        end
      rescue Exception
        halt 403, "Error"
      end
      halt 200
    end
  end
end

