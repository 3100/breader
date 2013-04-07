# -*- coding: utf-8 -*-

module BReader
  require 'slim'
  require 'zbar'
  require 'sinatra/base'
  require 'RMagick'

  class App < Sinatra::Base
    configure do
    end

    get '/' do
      slim :uploader
    end

    # for test
    get '/test' do
      file = Magick::Image.read('lib/public/image.jpg').first
      zbar = ZBar::Image.from_jpeg(file.to_blob).process
      puts zbar.inspect
    end

    post '/upload' do
      puts params[:photo][:tempfile]
      filepath = "lib/public/" + params[:photo][:filename]
      begin
        File.open(filepath, "wb") do |f|
          f.write(params[:photo][:tempfile].read)
        end
      rescue Exception
        halt 403, "Cannot upload the file. Select a proper jpeg file."
      end

      begin
        file = Magick::Image.read(filepath).first
        file.format = "PGM"
        file = file.resize_to_fit(400, 300)
        @zbar = ZBar::Image.from_pgm(file.to_blob).process.first
      rescue Exception
        halt 403, "Cannot read the barcode from your file."
      end
      slim :barcode
    end
  end
end

