class SparqlController < ApplicationController

	def sparql
		result = Drug.sparql_query(params[:query])
		render :xml => result.to_xml
	end

	def show

	end	

end