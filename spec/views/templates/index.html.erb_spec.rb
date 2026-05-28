require 'rails_helper'

RSpec.describe "templates/index", type: :view do
  before(:each) do
    assign(:templates, [
      Template.create!(
        nome: "Nome"
      ),
      Template.create!(
        nome: "Nome"
      )
    ])
  end

  it "renders a list of templates" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Nome".to_s), count: 2
  end
end
