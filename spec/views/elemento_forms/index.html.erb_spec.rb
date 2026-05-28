require 'rails_helper'

RSpec.describe "elemento_forms/index", type: :view do
  before(:each) do
    assign(:elemento_forms, [
      ElementoForm.create!(
        ordem: 2,
        enunciado: "Enunciado",
        formulario: nil
      ),
      ElementoForm.create!(
        ordem: 2,
        enunciado: "Enunciado",
        formulario: nil
      )
    ])
  end

  it "renders a list of elemento_forms" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Enunciado".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
