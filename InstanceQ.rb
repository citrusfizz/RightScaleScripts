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

  query="/api/instances?view=full&filter="+filters
  response = api16_call(query)

  body_data = response.body

  result = JSON.parse(body_data)

  return result
end


instances = all_instances

instances.each {|i|

#trim the last bit of the incarnator
#hack alert
i['security_groups'].each do |dd|

#puts i['security_groups']['name']
endlink = i['links']['incarnator']['href']
endlink.slice! "/api"
cloud = i['links']['cloud']['name']
network = i['networks'].first['href'].split("/").last
secgroup = dd['href'].split("/").last
resourceid = i['resource_uid']
sg = i['links']
#Build the url
#https://my.rightscale.com/acct/9202/servers/1201734003
url = credsapi+"/acct/"+accountn+endlink

puts "#{cloud},#{i['name']},#{resourceid},#{url},#{dd['name']},#{network},#{secgroup}"
end
}

