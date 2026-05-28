require 'rails_helper'

RSpec.describe "campos/index", type: :view do
  before(:each) do
    assign(:campos, [
      Campo.create!(
        ordem: 2,
        enunciado: "Enunciado",
        tipo_elemento: "Tipo Elemento",
        elemento: nil
      ),
      Campo.create!(
        ordem: 2,
        enunciado: "Enunciado",
        tipo_elemento: "Tipo Elemento",
        elemento: nil
      )
    ])
  end

  it "renders a list of campos" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Enunciado".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Tipo Elemento".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
