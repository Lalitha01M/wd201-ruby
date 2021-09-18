def get_command_line_argument

  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html

  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")


def parse_dns(dns_raw)

 # filtering the zone
  hash_codes = dns_raw.reject{ |line| line.start_with?("#") }
  hash_codes = hash_codes.reject{ |line| line.strip== "" }.join
  dns_record = Hash.new
  hash_codes_array = hash_codes.split("\n")
 
# split and creating hash
  hash_codes_array.each { |x| x = x.split(", ")
  dns_record[x[1]] = Hash.new()
  dns_record[x[1]][:type] = x[0]
  dns_record[x[1]][:target] = x[2]
  }
  return dns_record
end


def resolve(dns_records,lookup_chain,domain)

  rec=dns_records[domain]
  if rec
  if rec[:type]=="A"
     lookup_chain.push(rec[:target])
   elsif rec[:type]=="CNAME"
     lookup_chain.push(rec[:target])
     resolve(dns_records,lookup_chain,rec[:target])
  end
  else
     errorMessage = "Error: record not found for "+domain.to_s
     lookup_chain.push(errorMessage)
  end
end


# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
