require 'rails_helper'

RSpec.describe "resposta_elems/show", type: :view do
  before(:each) do
    assign(:resposta_elem, RespostaElem.create!(
      texto_resposta: "MyText",
      resposta_form: nil,
      elemento_form: nil,
      campo_form: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
