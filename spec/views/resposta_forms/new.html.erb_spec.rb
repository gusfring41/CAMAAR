require 'rails_helper'

RSpec.describe "resposta_forms/new", type: :view do
  before(:each) do
    assign(:resposta_form, RespostaForm.new(
      formulario: nil,
      usuario: nil
    ))
  end

  it "renders new resposta_form form" do
    render

    assert_select "form[action=?][method=?]", resposta_forms_path, "post" do

      assert_select "input[name=?]", "resposta_form[formulario_id]"

      assert_select "input[name=?]", "resposta_form[usuario_id]"
    end
  end
end
