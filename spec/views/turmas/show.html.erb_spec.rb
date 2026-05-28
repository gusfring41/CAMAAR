require 'rails_helper'

RSpec.describe "turmas/show", type: :view do
  before(:each) do
    assign(:turma, Turma.create!(
      numero_da_turma: "Numero Da Turma",
      semestre: "Semestre",
      horario: "Horario",
      disciplina: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Numero Da Turma/)
    expect(rendered).to match(/Semestre/)
    expect(rendered).to match(/Horario/)
    expect(rendered).to match(//)
  end
end
