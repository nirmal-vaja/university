class Api::V1::BlockExtraConfigsController < ApiController
  before_action :set_block_extra_config, only: %i[show update]

  def index
    @block_extra_configs = BlockExtraConfig.where(block_extra_configs_params)
    if @block_extra_configs
      render json: {
        message: "Found",
        data: {
          block_extra_configs: @block_extra_configs
        }, status: :ok
      }
    else
      render json: {
        message: "Not found",
        status: :unprocessable_entity
      }
    end
  end

  def show
    if @block_extra_config
      render json:{
        message: "Configs found",
        data: {
          block_extra_config: @block_extra_config
        }, status: :ok
      }
    else
      render json: {
        message: "Config not found",
        status: :unprocessable_entity
      }
    end
  end

  def update
    if @block_extra_config.update_attributes_if_changes(block_extra_configs_params)
      render json: {
        message: "Operation Successfull",
        data: {
          block_extra_config: @block_extra_config
        }, status: :ok
      }
    else
      render json: {
        message: @block_extra_config.errors.full_messages.join(' '),
        status: :unprocessable_entity
      }
    end
  end

  private

  def set_block_extra_config
    @block_extra_config = BlockExtraConfig.find_by_id(params[:id])
  end

  def block_extra_configs_params
    params.require(:block_extra_config).permit(:examination_name, :academic_year, :course_id, :date, :time, :number_of_extra_jr_supervision, :number_of_extra_sr_supervision, :examination_type, :number_of_supervisions )
  end
end