require "rails_helper"

RSpec.describe RespostaFormsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/resposta_forms").to route_to("resposta_forms#index")
    end

    it "routes to #new" do
      expect(get: "/resposta_forms/new").to route_to("resposta_forms#new")
    end

    it "routes to #show" do
      expect(get: "/resposta_forms/1").to route_to("resposta_forms#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/resposta_forms/1/edit").to route_to("resposta_forms#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/resposta_forms").to route_to("resposta_forms#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/resposta_forms/1").to route_to("resposta_forms#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/resposta_forms/1").to route_to("resposta_forms#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/resposta_forms/1").to route_to("resposta_forms#destroy", id: "1")
    end
  end
end
