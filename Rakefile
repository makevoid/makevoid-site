require_relative 'config/env'
require 'pp'

task :deploy do
  Rake::Task["rancher_finish"].invoke
  sh "docker build . -t makevoid/makevoid-site && docker push makevoid/makevoid-site:latest"
  Rake::Task["rancher_upgrade"].invoke
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

def basic_auth
  user, pass = Env["RANCHER_ACCESS_KEY"], Env["RANCHER_SECRET_KEY"]
  "Basic #{["#{user}:#{pass}"].pack("m*").gsub /\n/, ''}"
end

def get(url)
  uri = URI url
  req = Net::HTTP::Get.new uri
  req['Authorization'] = basic_auth
  resp = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
  Oj.load resp.body
end

def post(url, params)
  params = Oj.dump params
  uri = URI url
  req = Net::HTTP::Post.new uri
  req.body = params
  req["Content-Type"]  = "application/json"
  req['Authorization'] = basic_auth
  resp = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
  resp = Oj.load resp.body
  # puts "POST #{url}"
  # pp resp
  # puts
  resp
end

desc "rancher_launchconf"
task :rancher_launchconf do
  conf = get "http://ranch.mkv.run:8080/v2-beta/projects/1a5/services/1s12"
  puts Oj.dump conf["upgrade"]["inServiceStrategy"]
end


desc "rancher_upgrade"
task :rancher_upgrade do
  conf = get "http://ranch.mkv.run:8080/v2-beta/projects/1a5/services/1s12"
  strategy = conf["upgrade"]["inServiceStrategy"]
  project_id = "1a5"
  service_id = "1s12"
  params = {
    "inServiceStrategy" => strategy
  }
  post "http://ranch.mkv.run:8080/v2-beta/projects/#{project_id}/services/#{service_id}/?action=upgrade", params
end

desc "rancher_finish"
task :rancher_finish do
  project_id = "1a5"
  service_id = "1s12"
  post "http://ranch.mkv.run:8080/v2-beta/projects/#{project_id}/services/#{service_id}/?action=finishupgrade", {}
end
