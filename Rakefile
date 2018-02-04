require_relative 'config/env'
require 'pp'

task :deploy do

end

desc 'Run app with rerun'
task :run do
  sh "rerun -p \"**/*.{rb}\" -- bundle exec rackup"
end

desc "Dump graphql schema to json"
task :graphql_dump do
  GraphQL::Client.dump_schema GH::HTTP, "data/github_schema.json"
end

desc "Repos test call"
task :repos do
  repos = GH.repos
  pp repos
end
