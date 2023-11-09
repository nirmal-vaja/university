class Api::V1::HomeController < ApiController
  skip_before_action :doorkeeper_authorize!

  def get_authorization_details
    current_tenant = Apartment::Tenant.current
    Apartment::Tenant.switch!
    doorkeeper_client = Doorkeeper::Application.first
    Apartment::Tenant.switch!(current_tenant)

    render json: {
      doorkeeper: {
        name: doorkeeper_client.name,
        client_id: doorkeeper_client.uid,
        client_secret: doorkeeper_client.secret
      }, status: :ok
    }
  end

  def get_universities
    current_tenant = Apartment::Tenant.current
    Apartment::Tenant.switch!
    @accepted_universities = University.accepted
    @pending_universities = University.pending
    @rejected_universities = University.rejected

    render json: {
      accepted_universities: @accepted_universities,
      pending_universities: @pending_universities,
      rejected_universities: @rejected_universities,
      status: :ok
    }
  end

  def find_user
    found_user = User.find_by(id: doorkeeper_token[:resource_owner_id])

    if found_user.present?
      if found_user.show
        render json: {
          message: "User found",
          user: found_user,
          roles: found_user.roles.pluck(:name),
          configurations: found_user.configs,
          status: :ok
        }
      else
        role = found_user.roles.where.not(name: "faculty").first
        user = User.where(
          course_id: found_user.course.id,
          show: true
        ).with_role(role&.name).last
        if user
          render json: {
            message: "User found",
            user: user,
            roles: user.roles.pluck(:name),
            configurations: user.configs,
            status: :ok
          }
        else
          render json: {
            message: "User not found",
            status: :not_found
          }
        end
      end
    else
      render json: {
        message: "Invalid email address",
        status: :not_found
      }
    end
  end

  def check_subdomain
    current_tenants = Apartment.tenant_names
    current_tenant = Apartment::Tenant.current
    Apartment::Tenant.switch!
    if current_tenants.include?(params[:tenant_name])
      @university = University.find_by_subdomain(params[:tenant_name])
      if @university.status == "accepted"
        render json: {
          registered: true,
          accepted: true,
          status: :ok
        }
      else
        render json: {
          registered: true,
          accepted: false,
          status: :ok
        }
      end
    else
      render json: {
        registered: false,
        status: :ok
      }
    end
  end
end