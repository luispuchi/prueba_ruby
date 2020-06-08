require 'uri'
require 'net/http'
require 'json'
require 'openssl'


class RequestNasa
  def initialize (url, api_key)
    @url = url
    @api_key = api_key
    @uri = URI("#{@url}&api_key=#{@api_key}")
  end

  def request
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(@uri)
    response = http.request(request)
    hash = JSON.parse(response.read_body)
    buid_web_page(hash)
  end

  def buid_web_page(hash)
    html = '<html>
      <head>
      </head>
      <body>
      <ul>'

      hash['photos'].each do |a|
        html += "<li><img src='#{a['img_src']}'></li>"
      end

    html += '
      </ul>
      </body>
      </html>'


    File.open("index.html", "w+") do |f|
      f.write(html)
    end
    photos_count(hash)
  end

  def photos_count(hash)
    new_hash = []
    hash['photos'].each{|h| new_hash << {name: h['camera']['name'], quantity: h['rover']['total_photos']}}
    puts new_hash
  end
end

api_key = 'pGocQGbUuPUQ7mi8HzvKs2PLTCLrUF8Cd0iYschR' 
url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10'
obj = RequestNasa.new(url, api_key)
hash = obj.request
