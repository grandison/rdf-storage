require 'sxp'
require 'sparql/grammar'

class DrugPart < ActiveRecord::Base
	include Spira::Resource
	base_uri "http://osmanov.me/drug_parts/"
	property :name, :predicate => DC.title
	type URI.new("http://osmanov.me/drug_parts")

	def self.all
		sparql_query "SELECT * WHERE { ?s ?p ?o }"
	end
end