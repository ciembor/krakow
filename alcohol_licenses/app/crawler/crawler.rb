require 'nokogiri'
require 'open-uri'
require 'pry'
require 'fileutils'

module AlcoholLicenses
  class Crawler
    BIP_URL = 'https://www.bip.krakow.pl'
    ALCOHOL_LICENSES_PATH = "#{BIP_URL}/?dok_id=30394&vReg=2"
    DIR = 'data/files'

    def run
      page = Nokogiri::HTML(URI.open(ALCOHOL_LICENSES_PATH))
      edition_links = page.search('.techLabelBox .techRow a').map { |elements| elements.attributes['href'].value  }
      
      edition_links.each do |edition_link|
        meta = {}
        page = Nokogiri::HTML(URI.open(BIP_URL + edition_link))
        meta[:document_version_info] = page.search('.dok_wer_info').first.children.text
        meta[:data] = {}
        meta[:data][:detal] = page.at('p:contains("detal")').next.next.search('a').map do |element| 
          {element.text => element.attributes['href'].value}
        end
        meta[:data][:gastronomia] = page.at('p:contains("gastronomia")').next.next.search('a').map do |element|
          {element.text => element.attributes['href'].value}
        end  

        meta[:data].each do |type_of_activity, links|
          FileUtils.makedirs("#{DIR}/#{meta[:document_version_info]}/#{type_of_activity}")
          links.each do |link|
            page_url = link.values.first
            type_of_license = link.keys.first
            download_pdf(page_url, meta[:document_version_info], type_of_activity, type_of_license)
          end
        end  
      end
    end

    private

    def download_pdf(page_url, document_version_info, type_of_activity, type_of_license)
      puts("#{document_version_info} #{type_of_activity} #{type_of_license}")
      page = Nokogiri::HTML(URI.open(BIP_URL + page_url))
      pdf_url = page.at('a:contains("zobacz")').attributes["href"].value
      
      File.open("#{DIR}/#{document_version_info}/#{type_of_activity}/#{type_of_license}.pdf", 'wb') do |file|
        file.write URI::open(BIP_URL + pdf_url).read
      end
    end  
  end
end

AlcoholLicenses::Crawler.new.run
