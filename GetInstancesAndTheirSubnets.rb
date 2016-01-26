require 'yaml'
require 'right_api_client'
require 'json'

creds = YAML.load_file("#{ENV['HOME']}/.rest_connection/rest_api_config.yaml")

# Extract the account
creds[:account] = File.basename(creds[:api_url])

# Figure out url to hit:
creds[:api_url] = "https://"+URI.parse(creds[:api_url]).host


@endpoint = ARGV[1]

accountn = ARGV[0]
credsapi = creds[:api_url]
email = creds[:user]
pass = creds[:pass]

#@endpoint = URI.parse(credsapi).host

@client = RightApi::Client.new(:email => email, :password => pass,
                              :account_id => accountn, :api_url => credsapi,
                              :timeout => nil)
def api16_call(query)

  get  = Net::HTTP::Get.new(query)
  get['Cookie']        = @client.cookies.map { |key, value| "%s=%s" % [key, value] }.join(';')
  get['X-Api_Version'] = '1.6'
  get['X-Account']     = @client.account_id
  http = Net::HTTP.new(@endpoint, 443)
  http.use_ssl = true

  response = http.request(get)
  return response

  end


def all_instances()

  filters_list = "state=operational"
  filters = CGI::escape(filters_list)

  query="/api/instances?view=full"#&filter="#+filters
  response = api16_call(query)

  body_data = response.body

  result = JSON.parse(body_data)

  return result
end


instances = all_instances

instances.each do |i|
  print "#{i['name']} " # #{i['subnets']['name']}"


  i['subnets'].each do |s|
   print "   #{s['name']} "

  end
 puts ""
end

