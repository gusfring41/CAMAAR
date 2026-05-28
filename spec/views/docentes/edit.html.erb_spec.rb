require 'rails_helper'

RSpec.describe "docentes/edit", type: :view do
  let(:docente) {
    Docente.create!(
      matricula: "MyString",
      email: "MyString",
      nome: "MyString",
      formacao: "MyString"
    )
  }

  before(:each) do
    assign(:docente, docente)
  end

  it "renders the edit docente form" do
    render

    assert_select "form[action=?][method=?]", docente_path(docente), "post" do

      assert_select "input[name=?]", "docente[matricula]"

      assert_select "input[name=?]", "docente[email]"

      assert_select "input[name=?]", "docente[nome]"

      assert_select "input[name=?]", "docente[formacao]"
    end
  end
end
