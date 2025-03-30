namespace :dns do
  desc "Check current IP and update Cloudflare DNS if changed"
  task update: :environment do
    require 'net/http'
    require 'json'

    # Get current public IP
    current_ip = Net::HTTP.get(URI('https://api.ipify.org'))

    # Cloudflare credentials
    zone_id = Rails.application.credentials.cloudflare_zone_id
    dns_record_id = Rails.application.credentials.cloudflare_dns_record_id
    email = Rails.application.credentials.cloudflare_email
    api_key = Rails.application.credentials.cloudflare_secret

    # First, get the current DNS record
    uri = URI("https://api.cloudflare.com/client/v4/zones/#{zone_id}/dns_records/#{dns_record_id}")
    req = Net::HTTP::Get.new(uri)
    req['Content-Type'] = 'application/json'
    req['X-Auth-Email'] = email
    req['X-Auth-Key'] = api_key

    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true

    response = http.request(req)
    dns_data = JSON.parse(response.body)

    # Check if IP has changed
    if dns_data['success'] && dns_data['result']['content'] != current_ip
      puts "IP has changed from #{dns_data['result']['content']} to #{current_ip}. Updating..."

      # Update the DNS record
      req = Net::HTTP::Put.new(uri)
      req['Content-Type'] = 'application/json'
      req['X-Auth-Email'] = email
      req['X-Auth-Key'] = api_key

      # Keep existing values except for the content/IP
      record = dns_data['result']
      record['content'] = current_ip

      req.body = record.to_json
      response = http.request(req)

      if JSON.parse(response.body)['success']
        puts "Successfully updated DNS record to #{current_ip}"
      else
        puts "Failed to update DNS record: #{response.body}"
      end
    else
      puts "No IP change detected. Current IP: #{current_ip}"
    end
  end
end
