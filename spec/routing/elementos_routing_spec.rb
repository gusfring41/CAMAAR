require "rails_helper"

RSpec.describe ElementosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/elementos").to route_to("elementos#index")
    end

    it "routes to #new" do
      expect(get: "/elementos/new").to route_to("elementos#new")
    end

    it "routes to #show" do
      expect(get: "/elementos/1").to route_to("elementos#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/elementos/1/edit").to route_to("elementos#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/elementos").to route_to("elementos#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/elementos/1").to route_to("elementos#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/elementos/1").to route_to("elementos#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/elementos/1").to route_to("elementos#destroy", id: "1")
    end
  end
end
