require 'rails_helper'

RSpec.describe "elementos/edit", type: :view do
  let(:elemento) {
    Elemento.create!(
      ordem: 1,
      enunciado: "MyString",
      template: nil
    )
  }

  before(:each) do
    assign(:elemento, elemento)
  end

  it "renders the edit elemento form" do
    render

    assert_select "form[action=?][method=?]", elemento_path(elemento), "post" do
      assert_select "input[name=?]", "elemento[ordem]"

      assert_select "input[name=?]", "elemento[enunciado]"

      assert_select "input[name=?]", "elemento[template_id]"
    end
  end
end
