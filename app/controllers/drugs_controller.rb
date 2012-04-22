class DrugsController < ApplicationController

	def index
		@drugs = Drug.all
	end

	def show
		@drug = Drug.for(params[:id])
		respond_to do |format|
			format.html
			format.rdf {render :inline => @drug.to_rdf}
		end
	end

	def calc
		@drug_names = Drug.drug_names
	end

	def effects
		drugs = params["drugs"]
		if params["type"] == "contraindications"
			result = Drug.contraindications_of(drugs)
		end
		render :text => result
	end
end