require 'rails_helper'

RSpec.describe "campos/edit", type: :view do
  let(:campo) {
    Campo.create!(
      ordem: 1,
      enunciado: "MyString",
      tipo_elemento: "MyString",
      elemento: nil
    )
  }

  before(:each) do
    assign(:campo, campo)
  end

  it "renders the edit campo form" do
    render

    assert_select "form[action=?][method=?]", campo_path(campo), "post" do

      assert_select "input[name=?]", "campo[ordem]"

      assert_select "input[name=?]", "campo[enunciado]"

      assert_select "input[name=?]", "campo[tipo_elemento]"

      assert_select "input[name=?]", "campo[elemento_id]"
    end
  end
end
