require 'rails_helper'

RSpec.describe "resposta_elems/index", type: :view do
  before(:each) do
    assign(:resposta_elems, [
      RespostaElem.create!(
        texto_resposta: "MyText",
        resposta_form: nil,
        elemento_form: nil,
        campo_form: nil
      ),
      RespostaElem.create!(
        texto_resposta: "MyText",
        resposta_form: nil,
        elemento_form: nil,
        campo_form: nil
      )
    ])
  end

  it "renders a list of resposta_elems" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
