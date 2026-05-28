require 'rails_helper'

RSpec.describe "discentes/index", type: :view do
  before(:each) do
    assign(:discentes, [
      Discente.create!(
        matricula: "Matricula",
        email: "Email",
        nome: "Nome",
        formacao: "Formacao",
        curso: nil
      ),
      Discente.create!(
        matricula: "Matricula",
        email: "Email",
        nome: "Nome",
        formacao: "Formacao",
        curso: nil
      )
    ])
  end

  it "renders a list of discentes" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Matricula".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Nome".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Formacao".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
