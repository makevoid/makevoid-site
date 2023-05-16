require_relative 'config/env'
require 'pp'

task :deploy do
  # use new docker swarm rake based deployment
end

desc 'Run app with rerun'
task :run do
  # sh "rerun -p \"**/*.{rb}\" -- bundle exec rackup"
  sh "bundle exec rackup -p 3000"
end

task default: :run

desc "Dump graphql schema to json"
task :graphql_dump do
  GraphQL::Client.dump_schema GH::HTTP, "data/github_schema.json"
end

desc "Repos test call"
task :repos do
  repos = GH.repos
  pp repos
end

desc "Build docker container"
task :docker_build do
  sh "docker-compose build"
end

desc "Build and push container release to dockerhub"
task :docker_release do
  sh "docker-compose build && docker-compose push"
end

task release: :docker_release
