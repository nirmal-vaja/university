require 'razorpay/order'
require 'razorpay/customer'
key_id = ENV["RAZORPAY_KEY_ID"]
secret_key = ENV["RAZORPAY_SECRET_KEY"]
Razorpay.setup(key_id, secret_key)