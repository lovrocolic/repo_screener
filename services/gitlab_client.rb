require 'json'
require 'rest-client'

class GitlabClient
  PROJECTS_BASE_URL =
      'https://gitlab.com/api/v4/projects'.freeze
  GITLAB_ACCESS_TOKEN = ENV['GITLAB_TOKEN'].freeze

  def projects(programming_language)
    url = url programming_language
    libraries = JSON.parse response_body(url)

    libraries.map { |library| parse_response library }
  end

  private

  def response_body(url)
    begin
      RestClient::Request.execute(
        method: :get,
        url: url,
        timeout: 30,
        headers: {
          'Accept' => 'json',
          'PRIVATE-TOKEN' => GITLAB_ACCESS_TOKEN
        }
      ).body
    rescue RestClient::Exception => _e
      raise Exception
    end
  end

  def parse_response(project)
    {
      url: project['web_url'],
      username: username(project['owner']),
      name: project['name'],
      description: project['description'],
      host: 'gitlab'
    }
  end

  def url(language)
    attributes = 'order_by=updated_at&page=1&per_page=50'

    if language.nil?
      PROJECTS_BASE_URL + '?' + attributes
    else
      PROJECTS_BASE_URL + "?with_programming_language=#{language}&" + attributes
    end
  end

  def username(owner)
    owner.nil? ? '' : owner['username']
  end
end