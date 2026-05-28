require 'rails_helper'

RSpec.describe "resposta_forms/show", type: :view do
  before(:each) do
    assign(:resposta_form, RespostaForm.create!(
      formulario: nil,
      usuario: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
