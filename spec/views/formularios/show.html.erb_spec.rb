require 'rails_helper'

RSpec.describe "formularios/show", type: :view do
  before(:each) do
    assign(:formulario, Formulario.create!(
      turma: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
  end
end
