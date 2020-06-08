require 'uri'
require 'net/http'
require 'json'
require 'openssl'

def request(url_addres, api_key='pGocQGbUuPUQ7mi8HzvKs2PLTCLrUF8Cd0iYschR')
  url = URI("#{url_addres}&api_key=#{api_key}")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(url)
  request["User-Agent"] = 'PostmanRuntime/7.15.0'
  request["Accept"] = '*/*'
  request["Cache-Control"] = 'no-cache'
  request["Postman-Token"] = '95f7d1a0-04cf-40b1-8fba-66535ca6031a,59f71849-e627-46be-aaa0-7fe592a10416'
  request["Host"] = 'api.nasa.gov'
  request["cache-control"] = 'no-cache'
  response = http.request(request)
  JSON.parse(response.read_body)
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


File.open("index.html", "w+") do |f |
    f.write(html)
  end
end

def photos_count(hash)
hash_x = {}

hash["photos"].each do |i |
    nombre = i["camera"]["name"]
    if (hash_x[nombre])
        hash_x[nombre] += 1
    else
        hash_x[nombre] = 1
    end
end

puts hash_x
end

api_key = 'pGocQGbUuPUQ7mi8HzvKs2PLTCLrUF8Cd0iYschR'
url_addres = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10"
hash = request(url_addres, api_key)
buid_web_page(hash)
photos_count(hash)
