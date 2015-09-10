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

def find_distinct_countries(transactions)
  countries = {}
  transactions.each do |trans|
    countries[trans[2].split(' ')[1]] = true
  end
  p countries
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
  conversions
end

def get_currency_rates(conversions, currency)
  # find any exchange to desired rate
  rates ||= {}
  exchange = conversions.find{ |c| c[1] == currency }
  # we can already do the first exchange conversion
  # exchange = ["CAD", "USD", "1.0090"]
  rates[exchange[0]] = exchange[2].to_f
  conversions.delete exchange
  conversions.each do |c|
    # ["AUD", "CAD", "1.0079"]
    if c[1] == exchange[0]
      rates[c[0]] = exchange[2].to_f * c[2].to_f
      conversions.delete c
    end
    get_currency_rates(conversions, exchange[0])
  end
end

# load_conversions('RATES.xml')
find_distinct_countries(filter_transactions('DM1182'))
