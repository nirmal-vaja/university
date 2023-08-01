module Api
  module V1
    class PaymentsController < ApiController

      skip_before_action :doorkeeper_authorize!

      def create
        student = Student.find_by_id(params[:student_id])
        if student
          fee = student.semester.fee_details.find_by(academic_year: payment_params[:academic_year])

          if fee
            amount = (fee.amount.to_i) * 100

            razorpay_order = Razorpay::Order.create(amount: amount, currency: 'INR')
            if razorpay_order.present? && razorpay_order.attributes['id'].present?
              @payment = Payment.new(
                student_id: student.id,
                fee_detail_id: fee.id,
                razorpay_order_id: razorpay_order.attributes['id'],
                academic_year: payment_params[:academic_year],
                status: 'pending'
              )

              if @payment.save
                render json: {
                  message: "Payment has been initiated",
                  data: {
                    payment: @payment
                  }, status: :created
                }
              else
                render json: {
                  message: @payment.errors.full_messages.join(', '),
                  status: :unprocessable_entity
                }
              end
            else
              render json: {
                message: "Failed to create order with Razorpay.",
                status: :unprocessable_entity
              }
            end
          else
            render json: {
              message: "No fee details found for this student",
              status: :not_found
            }
          end
        else
          render json: {
            message: "Student not found",
            status: :not_found
          }
        end
      end

      def callback
        # Fetching payment_id from the request params or session
        order_id = params["order_id"]
        payment_id = params["payment_id"]

        razorpay_order = Razorpay::Order.fetch(order_id)
        if razorpay_order.attributes['status'] == 'paid'

          # Payment successful, marking fee as paid for the Student
          @payment = Payment.find_by(razorpay_order_id: order_id)
          @student = @payment.student
          Payment.where(academic_year: @payment.academic_year, student_id: params["student_id"]).where.not(razorpay_order_id: order_id).destroy_all
          if @payment.update(status: 'paid', razorpay_payment_id: payment_id)
            if @student.update(fees_paid: true)
              render json: {
                message: "Payment Successfull",
                status: :ok
              }
            end
          else
            render json: {
              message: @payment.errors.full_messages.join(', '),
              status: :unprocessable_entity
            }
          end
        else
          render json: {
            message: "Payment failed, please try again!",
            status: :unprocessable_entity
          }
        end
      end

      private

      def payment_params
        params.require(:payment).permit(:academic_year, :student_id, :fee_detail_id )
      end
    end
  end
end