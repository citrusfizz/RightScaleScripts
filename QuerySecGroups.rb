require 'rubygems'
require 'ap'
require 'right_api_client'
require 'io/console'

#ask for credentials and account #

puts "Enter your Right Scale email address"
email = gets.chomp

print "Enter your RightScale Password\n"
password = STDIN.noecho(&:gets).chomp

puts "Enter the account number to query"
accountn = gets.to_i
#instantiate RAC Object
@client = RightApi::Client.new(:email => email, :password => password, :account_id => accountn)


puts ""
puts ""
allClouds = @client.clouds.index
allClouds.each do |cloud|
  puts "Cloud: " + cloud.name
  cloud.security_groups.index.each do |secGroup|
    i=0 
    secGroup.security_group_rules.index.each do |rule|
      begin
       if rule.show.direction === "ingress"
         puts "  Security Group Name: " + secGroup.name
         sgroup = secGroup.show.links[1]['href'].split("/")[5]
         snetwork = secGroup.show.links[2]['href'].split("/")[3]
         puts "  Link: " + "https://us-4.rightscale.com/acct/" + accountn.to_s + "/network_manager#networks/" + snetwork + "/security_groups/" + sgroup
         i=i+1
         puts ""
         puts "    Rule ingress: " + i.to_s
         puts "      Source Type: " + rule.show.source_type
         puts "      CIDR IP: " + rule.show.cidr_ips
         puts "      Protocol: " + rule.show.protocol
         if rule.show.protocol != "all"
           puts "      Start Port | End Port: "
           puts "       " + rule.show.start_port + "             " + rule.show.end_port
         end

       end
      rescue => e
      next
      end
    end
    puts ""
  end
end

