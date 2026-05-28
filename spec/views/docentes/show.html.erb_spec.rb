require 'rails_helper'

RSpec.describe "docentes/show", type: :view do
  before(:each) do
    assign(:docente, Docente.create!(
      matricula: "Matricula",
      email: "Email",
      nome: "Nome",
      formacao: "Formacao"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Matricula/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(/Formacao/)
  end
end
