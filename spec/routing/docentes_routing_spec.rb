require "rails_helper"

RSpec.describe DocentesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/docentes").to route_to("docentes#index")
    end

    it "routes to #new" do
      expect(get: "/docentes/new").to route_to("docentes#new")
    end

    it "routes to #show" do
      expect(get: "/docentes/1").to route_to("docentes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/docentes/1/edit").to route_to("docentes#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/docentes").to route_to("docentes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/docentes/1").to route_to("docentes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/docentes/1").to route_to("docentes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/docentes/1").to route_to("docentes#destroy", id: "1")
    end
  end
end
