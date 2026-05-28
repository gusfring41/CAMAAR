require 'rails_helper'

RSpec.describe "elementos/index", type: :view do
  before(:each) do
    assign(:elementos, [
      Elemento.create!(
        ordem: 2,
        enunciado: "Enunciado",
        template: nil
      ),
      Elemento.create!(
        ordem: 2,
        enunciado: "Enunciado",
        template: nil
      )
    ])
  end

  it "renders a list of elementos" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Enunciado".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
