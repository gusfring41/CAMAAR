require 'rails_helper'

RSpec.describe "campo_forms/new", type: :view do
  before(:each) do
    assign(:campo_form, CampoForm.new(
      ordem: 1,
      enunciado: "MyString",
      elemento_form: nil
    ))
  end

  it "renders new campo_form form" do
    render

    assert_select "form[action=?][method=?]", campo_forms_path, "post" do

      assert_select "input[name=?]", "campo_form[ordem]"

      assert_select "input[name=?]", "campo_form[enunciado]"

      assert_select "input[name=?]", "campo_form[elemento_form_id]"
    end
  end
end
