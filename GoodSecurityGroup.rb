require 'yaml'
require 'right_api_client'
require 'json'

creds = YAML.load_file("#{ENV['HOME']}/.rest_connection/rest_api_config.yaml")

# Extract the account
creds[:account] = File.basename(creds[:api_url])

# Figure out url to hit:
creds[:api_url] = "https://"+URI.parse(creds[:api_url]).host

@endpoint = URI.parse(creds[:api_url]).host


accountn = ARGV[0]
credsapi = creds[:api_url]
email = creds[:user]
pass = creds[:pass]

@endpoint = URI.parse(credsapi).host

@client = RightApi::Client.new(:email => email, :password => pass,
                              :account_id => accountn, :api_url => credsapi,
                              :timeout => nil)


allClouds = @client.clouds.index
allClouds.each do |cloud|
  cloud.security_groups.index.each do |secGroup|
    secGroup.security_group_rules.index.each do |rule|
      begin
       if rule.show.direction === "ingress"
         sgroup = secGroup.show.links[1]['href'].split("/")[5]
         snetwork = secGroup.show.links[2]['href'].split("/")[3]
         print "#{cloud.name},#{secGroup.name},#{snetwork},#{sgroup},#{rule.show.source_type},#{rule.show.cidr_ips},#{rule.show.protocol},"
		 if rule.show.protocol != "all"
           puts "#{rule.show.start_port},#{rule.show.end_port}"
		 else
		    puts "all,all"
         end

       end
      rescue => e
      next
      end
    end
  end
end

