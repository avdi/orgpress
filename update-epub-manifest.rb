require 'rubygems'
require 'zip/zip'
require 'nokogiri'

include Zip
include Nokogiri

OPFNS      = "http://www.idpf.org/2007/opf"
NAMESPACES = { 'opf' => OPFNS }

abort "No filename given!" unless ARGV[0]
filename = ARGV[0]

ZipFile.open(filename) do |epub|
  font_file_names = epub.map{|e| e.name}.grep(/\.[ot]tf$/i)
  doc = epub.get_input_stream('content.opf') do |input|
    doc = Nokogiri::XML(input)
    manifest_elt = doc.at_xpath('//opf:manifest', NAMESPACES)
    font_file_names.each do |font_filename|
      puts "Adding manifest entry for #{font_filename}"
      item = XML::Node.new('item', doc)
      item["href"] = font_filename
      manifest_elt.add_child(item)
    end
    doc
  end
  epub.get_output_stream('content.opf') do |output|
    puts "Saving modifications to #{filename}"
    doc.write_to(output, :encoding => 'UTF-8')
  end
end
