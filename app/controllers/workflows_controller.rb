class WorkflowsController < ApplicationController
  before_action :set_workflow, only: %i[ show edit update destroy ]

  def zeebe_client
    ip = 'localhost' #'35.91.59.107' #localhost
    Zeebe::Client::GatewayProtocol::Gateway::Stub.new("#{ip}:26500", :this_channel_is_insecure)
  end

  def broadcast
    p params
    publish_message = zeebe_client.publish_message(Zeebe::Client::GatewayProtocol::PublishMessageRequest.new(
      {
        name: params[:message_name],
        correlationKey: params[:correlation_key],
        variables: params[:variables].to_json
      }
    ))
    p publish_message
    redirect_to vehicle_booking_complete_url(params[:correlation_key])
  end

  # GET /workflows or /workflows.json
  def index
    @workflows = Workflow.all
  end

  # GET /workflows/1 or /workflows/1.json
  def show
  end

  # GET /workflows/new
  def new
    @workflow = Workflow.new
  end

  # GET /workflows/1/edit
  def edit
  end

  # POST /workflows or /workflows.json
  def create
    @workflow = Workflow.new(workflow_params)

    respond_to do |format|
      if @workflow.save
        format.html { redirect_to workflow_url(@workflow), notice: "Workflow was successfully created." }
        format.json { render :show, status: :created, location: @workflow }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workflows/1 or /workflows/1.json
  def update
    respond_to do |format|
      if @workflow.update(workflow_params)
        format.html { redirect_to workflow_url(@workflow), notice: "Workflow was successfully updated." }
        format.json { render :show, status: :ok, location: @workflow }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workflows/1 or /workflows/1.json
  def destroy
    @workflow.destroy

    respond_to do |format|
      format.html { redirect_to workflows_url, notice: "Workflow was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workflow
      @workflow = Workflow.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def workflow_params
      params.require(:workflow).permit(:name, :process_id, :bpmn_diagram_file, :bpmn_image)
    end
end
