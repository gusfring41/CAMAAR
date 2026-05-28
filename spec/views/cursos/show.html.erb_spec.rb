require 'rails_helper'

RSpec.describe "cursos/show", type: :view do
  before(:each) do
    assign(:curso, Curso.create!(
      codigo: "Codigo",
      nome: "Nome",
      departamento: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Codigo/)
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(//)
  end
end
