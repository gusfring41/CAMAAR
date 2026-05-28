require "rails_helper"

RSpec.describe CamposController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/campos").to route_to("campos#index")
    end

    it "routes to #new" do
      expect(get: "/campos/new").to route_to("campos#new")
    end

    it "routes to #show" do
      expect(get: "/campos/1").to route_to("campos#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/campos/1/edit").to route_to("campos#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/campos").to route_to("campos#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/campos/1").to route_to("campos#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/campos/1").to route_to("campos#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/campos/1").to route_to("campos#destroy", id: "1")
    end
  end
end
