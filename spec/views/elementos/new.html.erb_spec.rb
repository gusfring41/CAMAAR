require 'rails_helper'

RSpec.describe "elementos/new", type: :view do
  before(:each) do
    assign(:elemento, Elemento.new(
      ordem: 1,
      enunciado: "MyString",
      template: nil
    ))
  end

  it "renders new elemento form" do
    render

    assert_select "form[action=?][method=?]", elementos_path, "post" do
      assert_select "input[name=?]", "elemento[ordem]"

      assert_select "input[name=?]", "elemento[enunciado]"

      assert_select "input[name=?]", "elemento[template_id]"
    end
  end
end
