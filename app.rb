require 'dotenv/load'
require 'sinatra'
require_relative 'services/gitlab_client'
require_relative 'services/github_client'

get "/api/libraries" do
  content_type :json

  programming_language = params['language']

  begin
    libraries_gitlab = GitlabClient.new.projects programming_language
    libraries_github = GithubClient.new.repositories programming_language

    (libraries_gitlab + libraries_github).to_json
  rescue Exception => _e
    halt 404
  end
end

not_found do
  'Whatever you are looking for can not be found!'
end
