require "rails_helper"

RSpec.describe DiscentesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/discentes").to route_to("discentes#index")
    end

    it "routes to #new" do
      expect(get: "/discentes/new").to route_to("discentes#new")
    end

    it "routes to #show" do
      expect(get: "/discentes/1").to route_to("discentes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/discentes/1/edit").to route_to("discentes#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/discentes").to route_to("discentes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/discentes/1").to route_to("discentes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/discentes/1").to route_to("discentes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/discentes/1").to route_to("discentes#destroy", id: "1")
    end
  end
end
