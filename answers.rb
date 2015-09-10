# parse the transaction File
require 'CSV'
require 'rexml/document'

def filter_transactions(trans_number)
  filtered_results = []
  CSV.foreach('TRANS.csv') do |line|
    filtered_results.push line if line[1] == trans_number
  end
  filtered_results
end

def load_conversions(conversion_file)
  doc = REXML::Document.new File.new(conversion_file)
  conversions = []

  doc.elements.each('*/rate') do |p|
    curr_conversion = []
    p.elements.each do |el|
      curr_conversion.push el.text
    end
    conversions.push curr_conversion
  end
end

load_conversions('RATES.xml')
