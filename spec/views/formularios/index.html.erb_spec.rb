require 'rails_helper'

RSpec.describe "formularios/index", type: :view do
  before(:each) do
    assign(:formularios, [
      Formulario.create!(
        turma: nil
      ),
      Formulario.create!(
        turma: nil
      )
    ])
  end

  it "renders a list of formularios" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
