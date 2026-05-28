require 'rails_helper'

RSpec.describe "turmas/edit", type: :view do
  let(:turma) {
    Turma.create!(
      numero_da_turma: "MyString",
      semestre: "MyString",
      horario: "MyString",
      disciplina: nil
    )
  }

  before(:each) do
    assign(:turma, turma)
  end

  it "renders the edit turma form" do
    render

    assert_select "form[action=?][method=?]", turma_path(turma), "post" do

      assert_select "input[name=?]", "turma[numero_da_turma]"

      assert_select "input[name=?]", "turma[semestre]"

      assert_select "input[name=?]", "turma[horario]"

      assert_select "input[name=?]", "turma[disciplina_id]"
    end
  end
end
