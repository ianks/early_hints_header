# typed: false
# frozen_string_literal: true

require "rack"
require "rack/test"

RSpec.shared_examples :early_hints do
  it "clears hanami assets thread local" do
    Thread.current[:__hanami_assets] = {}
    get "/"

    expect(Thread.current[:__hanami_assets]).to be_nil
  end
end

RSpec.describe EarlyHintsHeader::Middleware do
  include Rack::Test::Methods

  def app
    app = rack_app
    Rack::Builder.app do |_builder|
      use EarlyHintsHeader::Middleware
      run app
    end
  end

  context "without pre-existing Link header" do
    let(:rack_app) do
      lambda do |env|
        env["rack.early_hints"].call("Link" => "</assets/foo.js>; rel=preload; as=script")
        [200, {}, []]
      end
    end

    it_behaves_like :early_hints

    it "sets the Link header" do
      res = get "/"

      expect(res.headers["Link"]).to eql("</assets/foo.js>; rel=preload; as=script")
    end
  end

  context "with pre-existing Link header" do
    let(:rack_app) do
      lambda do |env|
        env["rack.early_hints"].call("Link" => "</assets/foo.js>; rel=preload; as=script")
        [200, {"Link" => "</assets/bar.js>; rel=preload; as=script"}, []]
      end
    end

    it_behaves_like :early_hints

    it "appends to the link header" do
      res = get "/"

      expect(res.headers["Link"]).to eql(
        "</assets/bar.js>; rel=preload; as=script,</assets/foo.js>; rel=preload; as=script"
      )
    end
  end

  context "when ios requests" do
    let(:rack_app) do
      lambda do |env|
        env["rack.early_hints"].call(
          "Link" => "</assets/foo.js>; rel=preload; as=script"
        )
        [200, {}, []]
      end
    end

    it_behaves_like :early_hints

    it "does not include the link header" do
      res = get(
        "/",
        {},
        "HTTP_USER_AGENT" => "Mozilla/5.0 (iPhone; CPU iPhone OS 11_4_1 like Mac OS X) " \
                             "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.0 Mobile/15E148 " \
                             "Safari/604.1"
      )

      expect(res.headers).not_to have_key("Link")
    end
  end
end
