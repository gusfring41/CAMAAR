require 'rails_helper'

RSpec.describe "campo_forms/show", type: :view do
  before(:each) do
    assign(:campo_form, CampoForm.create!(
      ordem: 2,
      enunciado: "Enunciado",
      elemento_form: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Enunciado/)
    expect(rendered).to match(//)
  end
end
