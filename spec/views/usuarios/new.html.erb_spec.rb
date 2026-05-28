require 'rails_helper'

RSpec.describe "usuarios/new", type: :view do
  before(:each) do
    assign(:usuario, Usuario.new(
      matricula: "MyString",
      email: "MyString",
      nome: "MyString",
      formacao: "MyString",
      type: ""
    ))
  end

  it "renders new usuario form" do
    render

    assert_select "form[action=?][method=?]", usuarios_path, "post" do

      assert_select "input[name=?]", "usuario[matricula]"

      assert_select "input[name=?]", "usuario[email]"

      assert_select "input[name=?]", "usuario[nome]"

      assert_select "input[name=?]", "usuario[formacao]"

      assert_select "input[name=?]", "usuario[type]"
    end
  end
end
