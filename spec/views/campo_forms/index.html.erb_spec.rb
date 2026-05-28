require 'rails_helper'

RSpec.describe "campo_forms/index", type: :view do
  before(:each) do
    assign(:campo_forms, [
      CampoForm.create!(
        ordem: 2,
        enunciado: "Enunciado",
        elemento_form: nil
      ),
      CampoForm.create!(
        ordem: 2,
        enunciado: "Enunciado",
        elemento_form: nil
      )
    ])
  end

  it "renders a list of campo_forms" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Enunciado".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
