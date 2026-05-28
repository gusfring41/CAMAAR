require 'rails_helper'

RSpec.describe "elementos/show", type: :view do
  before(:each) do
    assign(:elemento, Elemento.create!(
      ordem: 2,
      enunciado: "Enunciado",
      template: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Enunciado/)
    expect(rendered).to match(//)
  end
end
