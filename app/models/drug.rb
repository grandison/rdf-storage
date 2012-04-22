class Drug < ActiveRecord::Base
	include Spira::Resource
	base_uri "http://osmanov.me/drugs/"
	type URI.new("http://www4.wiwiss.fu-berlin.de/drugbank/resource/drugbank/drugs")
	property :intern_title, :predicate => URI.new("http://osmanov.me/intern_title"), :type => String
	property :brandName,  :predicate => FOAF.name, :type => String
	has_many :drugCategories, :predicate => URI.new("http://www4.wiwiss.fu-berlin.de/drugbank/resource/drugbank/drugType"), :type => :DrugCategory
	has_many :dosageForms, :predicate => URI.new("http://www4.wiwiss.fu-berlin.de/drugbank/resource/drugbank/dosageForm"), :type => String
	property :pharmacology, :predicate => URI.new("http://www4.wiwiss.fu-berlin.de/drugbank/resource/drugbank/pharmacology"), :type => String
	has_many :indications, :predicate => URI.new("http://www4.wiwiss.fu-berlin.de/drugbank/resource/drugbank/indication"), :type => String
	has_many :contraindications, :predicate => URI.new("http://www4.wiwiss.fu-berlin.de/dailymed/resource/dailymed/contraindication"), :type => String
	has_many :sideEffects, :predicate => URI.new("http://www4.wiwiss.fu-berlin.de/drugbank/resource/drugbank/toxicity"), :type => String
	property :dosage, :predicate => URI.new("http://osmanov.me/dosage"), :type => String
	has_many :interactions, :predicate => URI.new("http://www4.wiwiss.fu-berlin.de/drugbank/resource/drugbank/interactionInsert"), :type => String
	has_many :drugParts, :predicate => URI.new("http://osmanov.me/drugComponent"), :type => :DrugPart
	property :special, :predicate => URI.new("http://osmanov.me/special"), :type => String

# 	def contraindications
# 		repo = Spira.repositories[:default]
# 		sparql = SPARQL::Client.new("http://www4.wiwiss.fu-berlin.de/dailymed/sparql")
# 		query = "
# PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
# PREFIX dailymed: <http://www4.wiwiss.fu-berlin.de/dailymed/resource/dailymed/>
# SELECT DISTINCT ?contraindication

# WHERE {
#      ?moiety rdfs:label '#{name}' .
#      ?branded_drug dailymed:activeMoiety ?moiety ;
#                    dailymed:contraindication ?contraindication .
# }
# 		"
# 		sparql.query(query).map{|s| s[:contraindication] }
# 	end

	def similar
		query = "
			SELECT ?drug 
			WHERE {
				?drug <http://osmanov.me/drugComponent> ?drugPart .
				<#{uri}> <http://osmanov.me/drugComponent> ?drugPart
				FILTER (?drug != <#{uri}>)
			}
		"

		self.class.sparql_query(query).map{|d| d[:drug].as(Drug)}
	end

	def self.all
		query = "
			SELECT DISTINCT ?drug 
			WHERE {
				?drug <#{RDF.type}> <#{@type}>
			}
		"

		self.sparql_query(query).map{|d| d[:drug].as(Drug)}
	end

	def id
		uri.to_s.split("/")[-1]
	end

	def self.drug_names
		query = "
			SELECT DISTINCT ?drugname 
			WHERE {
				?drug <#{FOAF.name}> ?drugname
			}
		"

		self.sparql_query(query).map{|d| d[:drugname].to_s}
	end

	def self.contraindications_of(drugs)
		names_query = drugs.map do |drugname|
			"{ ?drug <#{FOAF.name}> '#{drugname}' }"
		end.join(" UNION ")
		query = "
				SELECT ?effects
				WHERE {
					#{names_query} .
					?drug <http://www4.wiwiss.fu-berlin.de/dailymed/resource/dailymed/contraindication> ?effects
				}
			"
		sparql_query(query).map(&:effects).join(",")
	end

	def self.toxicity_of(drugs)
		names_query = drugs.map do |drugname|
			"{ ?drug <#{FOAF.name}> '#{drugname}' }"
		end.join(" UNION ")
		query = "
				SELECT ?toxicity
				WHERE {
					#{names_query} .
					?drug <http://www4.wiwiss.fu-berlin.de/drugbank/resource/drugbank/toxicity> ?toxicity
				}
			"
		sparql_query(query).map(&:toxicity).join(",")
	end
end