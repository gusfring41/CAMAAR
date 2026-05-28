require 'rails_helper'

RSpec.describe "campos/show", type: :view do
  before(:each) do
    assign(:campo, Campo.create!(
      ordem: 2,
      enunciado: "Enunciado",
      tipo_elemento: "Tipo Elemento",
      elemento: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Enunciado/)
    expect(rendered).to match(/Tipo Elemento/)
    expect(rendered).to match(//)
  end
end
