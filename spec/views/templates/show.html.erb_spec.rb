require 'rails_helper'

RSpec.describe "templates/show", type: :view do
  before(:each) do
    assign(:template, Template.create!(
      nome: "Nome"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nome/)
  end
end
