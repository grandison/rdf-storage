module Spira
  module Resource
    def to_rdf
      RDF::RDFXML::Writer.buffer do |writer|
        self.each do |statement|
          writer << statement
        end
      end
    end
  end
end

