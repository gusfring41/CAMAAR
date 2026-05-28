require "rails_helper"

RSpec.describe CampoFormsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/campo_forms").to route_to("campo_forms#index")
    end

    it "routes to #new" do
      expect(get: "/campo_forms/new").to route_to("campo_forms#new")
    end

    it "routes to #show" do
      expect(get: "/campo_forms/1").to route_to("campo_forms#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/campo_forms/1/edit").to route_to("campo_forms#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/campo_forms").to route_to("campo_forms#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/campo_forms/1").to route_to("campo_forms#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/campo_forms/1").to route_to("campo_forms#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/campo_forms/1").to route_to("campo_forms#destroy", id: "1")
    end
  end
end
