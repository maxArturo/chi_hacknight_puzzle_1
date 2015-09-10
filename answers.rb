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
end

p filter_transactions('DM1182')
