require 'rails_helper'

RSpec.describe "resposta_elems/new", type: :view do
  before(:each) do
    assign(:resposta_elem, RespostaElem.new(
      texto_resposta: "MyText",
      resposta_form: nil,
      elemento_form: nil,
      campo_form: nil
    ))
  end

  it "renders new resposta_elem form" do
    render

    assert_select "form[action=?][method=?]", resposta_elems_path, "post" do
      assert_select "textarea[name=?]", "resposta_elem[texto_resposta]"

      assert_select "input[name=?]", "resposta_elem[resposta_form_id]"

      assert_select "input[name=?]", "resposta_elem[elemento_form_id]"

      assert_select "input[name=?]", "resposta_elem[campo_form_id]"
    end
  end
end
