class DrugCategory < ActiveRecord::Base
	include Spira::Resource
	base_uri "http://osmanov.me/drug_categories/"
	property :name, :predicate => DC.title
	type URI.new("http://osmanov.me/drug_parts")
end