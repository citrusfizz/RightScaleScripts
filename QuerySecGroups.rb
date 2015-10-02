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
s = @client.clouds.index
s.each do |l|
  puts "Cloud: " + l.name
  l.security_groups.index.each do |r|
    puts "  Security Group Name: " + r.name
    sgroup = r.show.links[1]['href'].split("/")[5]
    snetwork = r.show.links[2]['href'].split("/")[3]
    puts "  Link: " + "https://us-4.rightscale.com/acct/" + accountn.to_s + "/network_manager#networks/" + snetwork + "/security_groups/" + sgroup
    i=0 
    r.security_group_rules.index.each do |g|
      begin
        if g.show.direction === "ingress"
         i=i+1
         puts ""
         puts "    Rule ingress: " + i.to_s
         puts "      Source Type: " + g.show.source_type
         puts "      CIDR IP: " + g.show.cidr_ips
         puts "      Protocol: " + g.show.protocol
         if g.show.protocol != "all"
           puts "      Start Port | End Port: "
           puts "       " + g.show.start_port + "             " + g.show.end_port
         end

        end
      rescue => e
      next
      end
    end
    puts ""
  end
end

