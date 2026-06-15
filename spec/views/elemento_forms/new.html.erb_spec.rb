require 'rails_helper'

RSpec.describe "elemento_forms/new", type: :view do
  before(:each) do
    assign(:elemento_form, ElementoForm.new(
      ordem: 1,
      enunciado: "MyString",
      formulario: nil
    ))
  end

  it "renders new elemento_form form" do
    render

    assert_select "form[action=?][method=?]", elemento_forms_path, "post" do
      assert_select "input[name=?]", "elemento_form[ordem]"

      assert_select "input[name=?]", "elemento_form[enunciado]"

      assert_select "input[name=?]", "elemento_form[formulario_id]"
    end
  end
end
