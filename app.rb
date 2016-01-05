require 'open-uri'
require 'nokogiri'
require 'xpath'
require 'sinatra'
require 'slim'
require 'sass'

get('/styles.css'){ sass :styles, :style => :compressed, :views => './public/sass' }

@@currency_codes = {
  usd: 'R01235',
  eur: 'R01239',
  uah: 'R01720',
  tjs: 'R01670',
  kgs: 'R01370',
  kzt: 'R01335',
  czk: 'R01760'
}

helpers do
  def get_average_currency_value(date_begin, date_end, currency_code)
    url ="http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=#{date_begin}&date_req2=#{date_end}&VAL_NM_RQ=#{currency_code}"
    doc = Nokogiri::XML(open(url))
    records = doc.xpath("//Record")
    currency = 0.000
    records.each do |record|
      nominal = record.at_xpath("Nominal").text.to_i
      value = record.at_xpath("Value").text.gsub!(",",".").to_f
      currency += value / nominal
      currency.to_f
    end
    currency = currency / records.count
  end
end

get '/' do
  slim :index
end

get '/resualt/' do
  range = params.keys[0].split(' - ')
  @date_begin = Date.parse(range[0]).strftime("%d/%m/%Y")
  @date_end = Date.parse(range[1]).strftime("%d/%m/%Y")
  @currency_average_value = []
  @@currency_codes.each do |currency|
    value = get_average_currency_value(@date_begin, @date_end, currency[1])
    @currency_average_value << { currency[0] => value.to_f }
  end
   slim :resualt, layout: (request.xhr? ? false : :layout)
end
