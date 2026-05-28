require 'rails_helper'

RSpec.describe "docentes/index", type: :view do
  before(:each) do
    assign(:docentes, [
      Docente.create!(
        matricula: "Matricula",
        email: "Email",
        nome: "Nome",
        formacao: "Formacao"
      ),
      Docente.create!(
        matricula: "Matricula",
        email: "Email",
        nome: "Nome",
        formacao: "Formacao"
      )
    ])
  end

  it "renders a list of docentes" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Matricula".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Nome".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Formacao".to_s), count: 2
  end
end
