require 'rails_helper'

RSpec.describe "elemento_forms/show", type: :view do
  before(:each) do
    assign(:elemento_form, ElementoForm.create!(
      ordem: 2,
      enunciado: "Enunciado",
      formulario: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Enunciado/)
    expect(rendered).to match(//)
  end
end
