require 'rails_helper'

RSpec.describe "disciplinas/edit", type: :view do
  let(:disciplina) {
    Disciplina.create!(
      codigo: "MyString",
      nome: "MyString",
      departamento: nil
    )
  }

  before(:each) do
    assign(:disciplina, disciplina)
  end

  it "renders the edit disciplina form" do
    render

    assert_select "form[action=?][method=?]", disciplina_path(disciplina), "post" do

      assert_select "input[name=?]", "disciplina[codigo]"

      assert_select "input[name=?]", "disciplina[nome]"

      assert_select "input[name=?]", "disciplina[departamento_id]"
    end
  end
end
