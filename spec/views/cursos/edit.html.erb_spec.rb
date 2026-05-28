require 'rails_helper'

RSpec.describe "cursos/edit", type: :view do
  let(:curso) {
    Curso.create!(
      codigo: "MyString",
      nome: "MyString",
      departamento: nil
    )
  }

  before(:each) do
    assign(:curso, curso)
  end

  it "renders the edit curso form" do
    render

    assert_select "form[action=?][method=?]", curso_path(curso), "post" do

      assert_select "input[name=?]", "curso[codigo]"

      assert_select "input[name=?]", "curso[nome]"

      assert_select "input[name=?]", "curso[departamento_id]"
    end
  end
end
