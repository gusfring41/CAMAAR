require 'rails_helper'

RSpec.describe "turmas/new", type: :view do
  before(:each) do
    assign(:turma, Turma.new(
      numero_da_turma: "MyString",
      semestre: "MyString",
      horario: "MyString",
      disciplina: nil
    ))
  end

  it "renders new turma form" do
    render

    assert_select "form[action=?][method=?]", turmas_path, "post" do
      assert_select "input[name=?]", "turma[numero_da_turma]"

      assert_select "input[name=?]", "turma[semestre]"

      assert_select "input[name=?]", "turma[horario]"

      assert_select "input[name=?]", "turma[disciplina_id]"
    end
  end
end
