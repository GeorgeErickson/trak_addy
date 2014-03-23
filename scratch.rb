$:.unshift 'lib'
require 'trak_addy'
require 'pry'

TrakAddy.config do |c|
  c.api_key = ENV['API_KEY']
end


job = TrakAddy::Job.create({
  recipientPhoneNumber: '904-654-3025',
  destination: {
    coordinates: ['-71.0659025', '42.3521846']
  },
  address: {}
})
puts job.inspect


# driver = TrakAddy::Driver.all()
# puts TrakAddy.client.post('jobs', '{
#    "recipientPhoneNumber":"877-764-8725",
#    "destination":{
#     "coordinates":["-122.39719301462173","37.78530664103291"]
#    },
#    "recipientData":{
#     "name":"Addy Dev Team1"
#    },
#    "address":{
#     "number":"620",
#     "street":"Folsom Street",
#     "city":"San Francisco",
#     "state":"California",
#     "country":"USA"
#    }
# }')
