require 'rails_helper'

RSpec.describe "elemento_forms/edit", type: :view do
  let(:elemento_form) {
    ElementoForm.create!(
      ordem: 1,
      enunciado: "MyString",
      formulario: nil
    )
  }

  before(:each) do
    assign(:elemento_form, elemento_form)
  end

  it "renders the edit elemento_form form" do
    render

    assert_select "form[action=?][method=?]", elemento_form_path(elemento_form), "post" do
      assert_select "input[name=?]", "elemento_form[ordem]"

      assert_select "input[name=?]", "elemento_form[enunciado]"

      assert_select "input[name=?]", "elemento_form[formulario_id]"
    end
  end
end
