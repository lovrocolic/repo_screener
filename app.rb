require 'dotenv/load'
require 'sinatra'
require_relative 'services/gitlab_client'
require_relative 'services/github_client'

ALLOWED_LANGUAGES = %w[java ruby javascript go python].freeze

get "/api/libraries" do
  content_type :json

  programming_language = params['language']
  validate_programming_language programming_language if programming_language

  begin
    libraries_gitlab = GitlabClient.new.projects programming_language
    libraries_github = GithubClient.new.repositories programming_language

    (libraries_gitlab + libraries_github).to_json
  rescue RestClient::ExceptionWithResponse => _e
    halt 502, 'Upstream server error!'
  rescue StandardError => _e
    halt 500, 'Internal server error!'
  end
end

private

def validate_programming_language(programming_language)
  message = 'Invalid Programming language!'
  halt 400, message unless ALLOWED_LANGUAGES.include? programming_language
end
