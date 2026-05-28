require "rails_helper"

RSpec.describe ElementoFormsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/elemento_forms").to route_to("elemento_forms#index")
    end

    it "routes to #new" do
      expect(get: "/elemento_forms/new").to route_to("elemento_forms#new")
    end

    it "routes to #show" do
      expect(get: "/elemento_forms/1").to route_to("elemento_forms#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/elemento_forms/1/edit").to route_to("elemento_forms#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/elemento_forms").to route_to("elemento_forms#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/elemento_forms/1").to route_to("elemento_forms#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/elemento_forms/1").to route_to("elemento_forms#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/elemento_forms/1").to route_to("elemento_forms#destroy", id: "1")
    end
  end
end
