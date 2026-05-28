require 'rails_helper'

RSpec.describe "docentes/new", type: :view do
  before(:each) do
    assign(:docente, Docente.new(
      matricula: "MyString",
      email: "MyString",
      nome: "MyString",
      formacao: "MyString"
    ))
  end

  it "renders new docente form" do
    render

    assert_select "form[action=?][method=?]", docentes_path, "post" do

      assert_select "input[name=?]", "docente[matricula]"

      assert_select "input[name=?]", "docente[email]"

      assert_select "input[name=?]", "docente[nome]"

      assert_select "input[name=?]", "docente[formacao]"
    end
  end
end
