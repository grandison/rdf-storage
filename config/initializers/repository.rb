require 'do_sqlite3'

repository = RDF::DataObjects::Repository.new "sqlite3:base.db"
Spira.add_repository!(:default, repository)

class ActiveRecord::Base
  def self.sparql_query(query)
    repo = Spira.repositories[:default]
    @repository ||= RDF::Repository.new do |graph|
      repo.each do |st|
          graph << [st.subject, st.predicate, st.object]
      end
    end
    SPARQL.execute(query, @repository)
  end
end
