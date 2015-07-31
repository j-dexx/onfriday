class Sagepay
  
  require "base64"
  require "openssl"
  
  def self.vps_protocol
    "2.23"
  end
  
  def self.simulator_url
    "https://test.sagepay.com/Simulator/VSPFormGateway.asp"
  end
  
  def self.test_url  
    "https://test.sagepay.com/gateway/service/vspform-register.vsp"
  end
  
  def self.live_url
    "https://live.sagepay.com/gateway/service/vspform-register.vsp"
  end
  
  def self.tx_type
    "PAYMENT"
  end
  
  def self.encryption_key
    # real
    "p4kAZ5APeLZ6qwHQ"
    
    # eskimo
    # "JF1Row8NX2isLp0a"
  end
  
  def self.vendor
    # real
    "7330897"
    
    # eskimo
    # "eskimosoup"
  end  

  def self.crypt(
    vendor_tx_code, 
    amount, 
    description, 
    email,
    billing_first_names,
    billing_surname, 
    billing_address_1, 
    billing_address_2, 
    billing_city, 
    billing_postcode, 
    billing_country, 
    delivery_first_names,
    delivery_surname, 
    delivery_address_1, 
    delivery_address_2, 
    delivery_city, 
    delivery_postcode, 
    delivery_country, 
    success_url, 
    failure_url,
    billing_state,
    delivery_state
    )
    name_value_pairs = [
                        ["VendorTxCode", "#{ActiveSupport::SecureRandom.base64(10).gsub(/\W/, '')}---#{vendor_tx_code}"],
                        ["Amount", amount],
                        ["Description", "#{vendor_tx_code} - #{description}"],
                        ["SuccessURL", success_url],
                        ["FailureURL", failure_url],
                        ["Currency", "GBP"],
                        ["CustomerEMail", email],
                        ["BillingSurname", billing_surname],
                        ["BillingFirstnames", billing_first_names],
                        ["BillingAddress1", billing_address_1],
                        ["BillingAddress2", billing_address_2],
                        ["BillingCity", billing_city],
                        ["BillingPostcode", billing_postcode],
                        ["BillingCountry", billing_country],
                        ["DeliverySurname", delivery_surname],
                        ["DeliveryFirstnames", delivery_first_names],
                        ["DeliveryAddress1", delivery_address_1],
                        ["DeliveryAddress2", delivery_address_2],
                        ["DeliveryCity", delivery_city],
                        ["DeliveryPostcode", delivery_postcode],
                        ["DeliveryCountry", delivery_country]
                       ]
    name_value_pairs += [["BillingState", billing_state]] if billing_country == 'US'
    name_value_pairs += [["DeliveryState", delivery_state]] if delivery_country == 'US'
    unencrypted = name_value_pairs.map{|k,v| "#{k}=#{v}"}.join("&")
    encrypted = Base64.encode64(simple_xor(unencrypted, self.encryption_key))
    return encrypted
  end

  def self.decrypt(crypt)
    plain = simple_xor(Base64.decode64(crypt.gsub(" ", "+")), self.encryption_key)
    name_value_pairs = plain.split("&")
    result_hash = {}
    name_value_pairs.each do |name_value_pair|
      key = name_value_pair.split("=")[0]
      value = name_value_pair.split("=")[1]
      result_hash[key] = value
      puts key
      puts value
    end
    return result_hash
  end

  def self.simple_xor(data, key)
    i = 0
    out = ""
    data.each_byte do |chr|
      out += (chr^(key[i%key.length])).chr
      i = i + 1
    end
    return out
  end

  
end
