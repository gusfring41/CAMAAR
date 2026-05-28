require 'rails_helper'

RSpec.describe "usuarios/show", type: :view do
  before(:each) do
    assign(:usuario, Usuario.create!(
      matricula: "Matricula",
      email: "Email",
      nome: "Nome",
      formacao: "Formacao",
      type: "Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Matricula/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(/Formacao/)
    expect(rendered).to match(/Type/)
  end
end
