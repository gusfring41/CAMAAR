require 'rails_helper'

RSpec.describe "resposta_forms/edit", type: :view do
  let(:resposta_form) {
    RespostaForm.create!(
      formulario: nil,
      usuario: nil
    )
  }

  before(:each) do
    assign(:resposta_form, resposta_form)
  end

  it "renders the edit resposta_form form" do
    render

    assert_select "form[action=?][method=?]", resposta_form_path(resposta_form), "post" do

      assert_select "input[name=?]", "resposta_form[formulario_id]"

      assert_select "input[name=?]", "resposta_form[usuario_id]"
    end
  end
end
