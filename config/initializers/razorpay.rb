require 'razorpay/order'
require 'razorpay/customer'
key_id = "rzp_test_tZlQ1CoRvo4DTY"
secret_key = "J9eweDdSrtLw4PKeJrVyCkbC"
Rails.logger.info "RAZORPAY_KEY_ID: #{ENV['RAZORPAY_KEY_ID']}"
Rails.logger.info "RAZORPAY_SECRET_KEY: #{ENV['RAZORPAY_SECRET_KEY']}"
Razorpay.setup(key_id, secret_key)