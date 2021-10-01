

#https://medium.com/building-rigup/wrangling-google-services-in-ruby-5493e906c84f
#https://spin.atomicobject.com/2016/07/16/google-sheets-api-ruby/
#https://www.botreetechnologies.com/blog/google-api-authorization-with-ruby-using-long-lasting-refresh-token

require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'date'

class JiraConnect
  @email = ""
  @token = ""

  def initialize(email, token)
    @email = email
    @token = token
  end

  def get_jira_components_from_cache(filename)

  end

  def get_jira_components()
    uriString="https://leadtechie.atlassian.net/rest/api/3/project/TEST/components"
    data = get_jira_api(uriString)
    #puts data
    data
  end

  def parseComponentsJSON(data)
      results = []
      jsondata=JSON.parse(data)
      jsondata.each do |hash|
        results.push( [ DateTime::now,
                     hash["id"],
                     hash["name"],
                     hash['lead'] ? hash['lead']['displayName'] : "<No Owner>",
                     hash['description']?hash['description']:'<No Description>'
                   ])
      end
      results
    end

  def save_jira_components(data, fileName)
    File.open("sample_data/cache/"+fileName, 'w') {|f| f.write(JSON.pretty_generate(data)) }
  end

  def get_cached_json(fileName)
    data = File.read("test/sample_data/cache/"+fileName)
  end

  def get_sample_json(fileName)
    #puts "Current Directory"
    #puts Dir.pwd
    data = File.read("test/sample_data/"+fileName)
  end

  def get_jira_api(uriIn)
    uri = URI(uriIn)

    Net::HTTP.start(uri.host, uri.port,
      :use_ssl => uri.scheme == 'https',
      :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Get.new uri.request_uri
      request.basic_auth @email, @token
      response = http.request request # Net::HTTPResponse object

      #puts response.body


      data = JSON.parse(response.body)
    end
  end

  def get_jira_api2(dataIn)
    dataOut = []
    data.each do |component|
      dataOut << [component['name'], component['displayName']]
    end
  end

# def get_jira_api(dataIn)
#    data.each do |child|
#        puts child['id'] + " " + child['name'] + " " + ( child['lead'] ? child['lead']['displayName'] : "(No Owner)") + " " + (child['description']?child['description']:'No Description')
#    end
#  end

  def parse_component_list()
    data.each do |component|
      puts component['name']
      puts component['displayName']
    end
  end
end
