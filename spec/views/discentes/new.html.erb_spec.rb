require 'rails_helper'

RSpec.describe "discentes/new", type: :view do
  before(:each) do
    assign(:discente, Discente.new(
      matricula: "MyString",
      email: "MyString",
      nome: "MyString",
      formacao: "MyString",
      curso: nil
    ))
  end

  it "renders new discente form" do
    render

    assert_select "form[action=?][method=?]", discentes_path, "post" do
      assert_select "input[name=?]", "discente[matricula]"

      assert_select "input[name=?]", "discente[email]"

      assert_select "input[name=?]", "discente[nome]"

      assert_select "input[name=?]", "discente[formacao]"

      assert_select "input[name=?]", "discente[curso_id]"
    end
  end
end
