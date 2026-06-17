class UsuariosController < ApplicationController
  before_action :require_login
  before_action :require_admin, except: [ :avaliacoes, :responder_formulario, :submeter_resposta ]
  before_action :set_usuario, only: %i[ show edit update destroy ]

  def avaliacoes
    @usuario = Usuario.find(params[:usuario_id])

    if @usuario.is_a?(Docente)
      @turmas = @usuario.turmas
    elsif @usuario.is_a?(Discente)
      @turmas = @usuario.turmas
    else
      @turmas = Turma.none
    end

    @avaliacoes = Formulario
      .joins(:turma)
      .where(turma: @turmas)
      .includes(turma: { disciplina: :departamento, docentes: [] })
  end

  def responder_formulario
    @usuario = Usuario.find(params[:usuario_id])
    @formulario = Formulario.includes(elemento_forms: :campo_forms).find(params[:formulario_id])

    if RespostaForm.exists?(formulario: @formulario, usuario: current_user)
      redirect_to usuarios_avaliacoes_path(@usuario), notice: "Você já respondeu este formulário."
    end
  end

  def submeter_resposta
    @usuario = Usuario.find(params[:usuario_id])
    @formulario = Formulario.includes(elemento_forms: :campo_forms).find(params[:formulario_id])

    if RespostaForm.exists?(formulario: @formulario, usuario: current_user)
      redirect_to usuarios_avaliacoes_path(@usuario), alert: "Você já respondeu este formulário." and return
    end

    respostas_em_branco = @formulario.elemento_forms.order(:ordem).any? do |ef|
      params.dig(:respostas, ef.id.to_s).blank?
    end

    if respostas_em_branco
      flash.now[:alert] = "Por favor, responda todas as perguntas obrigatórias"
      render :responder_formulario, status: :unprocessable_content and return
    end

    resposta_form = RespostaForm.new(
      formulario: @formulario,
      usuario: current_user,
      data_submissao: Date.today
    )

    ActiveRecord::Base.transaction do
      resposta_form.save!

      @formulario.elemento_forms.order(:ordem).each do |ef|
        resposta_val = params.dig(:respostas, ef.id.to_s)
        next if resposta_val.blank?

        if ef.tipo == "Texto"
          resposta_form.resposta_elems.create!(
            elemento_form: ef,
            texto_resposta: resposta_val
          )
        else
          campo = ef.campo_forms.find_by(id: resposta_val)
          next unless campo

          resposta_form.resposta_elems.create!(
            elemento_form: ef,
            campo_form: campo,
            texto_resposta: campo.enunciado
          )
        end
      end
    end

    redirect_to usuarios_avaliacoes_path(@usuario), notice: "Respostas enviadas com sucesso!"
  rescue ActiveRecord::RecordInvalid => e
    @formulario = Formulario.includes(elemento_forms: :campo_forms).find(params[:formulario_id])
    flash.now[:alert] = "Erro ao salvar respostas: #{e.message}"
    render :responder_formulario, status: :unprocessable_content
  end

  # GET /usuarios or /usuarios.json
  def index
    @usuarios = Usuario.all
  end

  # GET /usuarios/1 or /usuarios/1.json
  def show
  end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
  end

  # GET /usuarios/1/edit
  def edit
  end

  # POST /usuarios or /usuarios.json
  def create
    @usuario = Usuario.new(usuario_params)

    respond_to do |format|
      if @usuario.save
        format.html { redirect_to @usuario, notice: "Usuario was successfully created." }
        format.json { render :show, status: :created, location: @usuario }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @usuario.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /usuarios/1 or /usuarios/1.json
  def update
    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { redirect_to @usuario, notice: "Usuario was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @usuario.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /usuarios/1 or /usuarios/1.json
  def destroy
    @usuario.destroy!

    respond_to do |format|
      format.html { redirect_to usuarios_path, notice: "Usuario was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def usuario_params
      params.expect(usuario: [ :matricula, :email, :nome, :formacao, :type ])
    end
end
