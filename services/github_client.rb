require 'json'
require 'rest-client'

class GithubClient
  REPOSITORIES_BASE_URL =
      'https://api.github.com/graphql'.freeze
  GITHUB_ACCESS_TOKEN = ENV['GITHUB_TOKEN'].freeze

  def repositories(programming_language)
    payload = payload(programming_language).to_json
    libraries = JSON.parse(response_body(payload))['data']['search']['edges']

    libraries.map { |library| parse_response library['node'] }
  end

  private

  def response_body(payload)
    begin
      RestClient::Request.execute(
        method: :post,
        url: REPOSITORIES_BASE_URL,
        payload: payload,
        timeout: 30,
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{GITHUB_ACCESS_TOKEN}"
        }
      ).body
    rescue RestClient::Exception => _e
      raise Exception
    end
  end

  def parse_response(repo)
    {
      url: repo['url'],
      username: repo['owner']['login'],
      name: repo['name'],
      description: repo['description'],
      host: 'github'
    }
  end

  def payload(language)
    if language.nil?
      {"query" => "{search(query:\"is:public sort:updated\",type: REPOSITORY,first: 50){edges{node{... on Repository {name\nurl\nowner{login}\ndescription}}}}}"}
    else
      {"query" => "{search(query:\"is:public sort:updated language:#{language}\",type: REPOSITORY,first: 50){edges{node{... on Repository {name\nurl\nowner{login}\ndescription}}}}}"}
    end
  end
end