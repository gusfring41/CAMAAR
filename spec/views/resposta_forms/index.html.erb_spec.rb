require 'rails_helper'

RSpec.describe "resposta_forms/index", type: :view do
  before(:each) do
    assign(:resposta_forms, [
      RespostaForm.create!(
        formulario: nil,
        usuario: nil
      ),
      RespostaForm.create!(
        formulario: nil,
        usuario: nil
      )
    ])
  end

  it "renders a list of resposta_forms" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
