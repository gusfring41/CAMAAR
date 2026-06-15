require 'rails_helper'

RSpec.describe "campo_forms/edit", type: :view do
  let(:campo_form) {
    CampoForm.create!(
      ordem: 1,
      enunciado: "MyString",
      elemento_form: nil
    )
  }

  before(:each) do
    assign(:campo_form, campo_form)
  end

  it "renders the edit campo_form form" do
    render

    assert_select "form[action=?][method=?]", campo_form_path(campo_form), "post" do
      assert_select "input[name=?]", "campo_form[ordem]"

      assert_select "input[name=?]", "campo_form[enunciado]"

      assert_select "input[name=?]", "campo_form[elemento_form_id]"
    end
  end
end
