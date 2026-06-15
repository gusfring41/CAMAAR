require 'rails_helper'

RSpec.describe "cursos/new", type: :view do
  before(:each) do
    assign(:curso, Curso.new(
      codigo: "MyString",
      nome: "MyString",
      departamento: nil
    ))
  end

  it "renders new curso form" do
    render

    assert_select "form[action=?][method=?]", cursos_path, "post" do
      assert_select "input[name=?]", "curso[codigo]"

      assert_select "input[name=?]", "curso[nome]"

      assert_select "input[name=?]", "curso[departamento_id]"
    end
  end
end
