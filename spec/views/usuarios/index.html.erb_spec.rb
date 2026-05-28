require 'rails_helper'

RSpec.describe "usuarios/index", type: :view do
  before(:each) do
    assign(:usuarios, [
      Usuario.create!(
        matricula: "Matricula",
        email: "Email",
        nome: "Nome",
        formacao: "Formacao",
        type: "Type"
      ),
      Usuario.create!(
        matricula: "Matricula",
        email: "Email",
        nome: "Nome",
        formacao: "Formacao",
        type: "Type"
      )
    ])
  end

  it "renders a list of usuarios" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Matricula".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Nome".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Formacao".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Type".to_s), count: 2
  end
end
