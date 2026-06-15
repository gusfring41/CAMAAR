require 'rails_helper'

RSpec.describe "discentes/edit", type: :view do
  let(:discente) {
    Discente.create!(
      matricula: "MyString",
      email: "MyString",
      nome: "MyString",
      formacao: "MyString",
      curso: nil
    )
  }

  before(:each) do
    assign(:discente, discente)
  end

  it "renders the edit discente form" do
    render

    assert_select "form[action=?][method=?]", discente_path(discente), "post" do
      assert_select "input[name=?]", "discente[matricula]"

      assert_select "input[name=?]", "discente[email]"

      assert_select "input[name=?]", "discente[nome]"

      assert_select "input[name=?]", "discente[formacao]"

      assert_select "input[name=?]", "discente[curso_id]"
    end
  end
end
