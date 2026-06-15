class TemplatesController < ApplicationController
  layout "gerenciamento"

  before_action :set_template, only: %i[ show edit update destroy ]

  # GET /templates or /templates.json
  def index
    @templates = Template.all
  end

  # GET /templates/1 or /templates/1.json
  def show
    redirect_to admin_templates_path
  end

  # GET /templates/new
  def new
    @templates = Template.all
    @template = Template.new
    elemento = @template.elementos.build
    elemento.campos.build
  end

  # GET /templates/1/edit
  def edit
    @templates = Template.all
    if @template.elementos.empty?
      elemento = @template.elementos.build
      elemento.campos.build
    end
  end

  # POST /templates or /templates.json
  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to admin_templates_path, notice: "Template criado com sucesso!" }
        format.json { render :show, status: :created, location: @template }
      else
        @templates = Template.all
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @template.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /templates/1 or /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to admin_templates_path, notice: "Template atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @template }
      else
        @templates = Template.all
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @template.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /templates/1 or /templates/1.json
  def destroy
    @template.destroy!
    respond_to do |format|
      # Mude templates_path para admin_templates_path
      format.html { redirect_to admin_templates_path, notice: "Template deletado com sucesso!", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def template_params
      params.require(:template).permit(
        :nome,
        elementos_attributes: [
          :id, :enunciado, :ordem, :_destroy,
          campos_attributes: [ :id, :tipo_elemento, :enunciado, :ordem, :_destroy ]
        ]
      )
    end
end
