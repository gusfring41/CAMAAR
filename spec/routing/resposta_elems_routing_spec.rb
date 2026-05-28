require "rails_helper"

RSpec.describe RespostaElemsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/resposta_elems").to route_to("resposta_elems#index")
    end

    it "routes to #new" do
      expect(get: "/resposta_elems/new").to route_to("resposta_elems#new")
    end

    it "routes to #show" do
      expect(get: "/resposta_elems/1").to route_to("resposta_elems#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/resposta_elems/1/edit").to route_to("resposta_elems#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/resposta_elems").to route_to("resposta_elems#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/resposta_elems/1").to route_to("resposta_elems#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/resposta_elems/1").to route_to("resposta_elems#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/resposta_elems/1").to route_to("resposta_elems#destroy", id: "1")
    end
  end
end
