require 'rails_helper'

RSpec.describe "discentes/show", type: :view do
  before(:each) do
    assign(:discente, Discente.create!(
      matricula: "Matricula",
      email: "Email",
      nome: "Nome",
      formacao: "Formacao",
      curso: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Matricula/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(/Formacao/)
    expect(rendered).to match(//)
  end
end
