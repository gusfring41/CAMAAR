require 'rails_helper'

RSpec.describe "cursos/index", type: :view do
  before(:each) do
    assign(:cursos, [
      Curso.create!(
        codigo: "Codigo",
        nome: "Nome",
        departamento: nil
      ),
      Curso.create!(
        codigo: "Codigo",
        nome: "Nome",
        departamento: nil
      )
    ])
  end

  it "renders a list of cursos" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Codigo".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Nome".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
