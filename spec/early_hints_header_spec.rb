RSpec.describe EarlyHintsHeader do
  it "has a version number" do
    expect(EarlyHintsHeader::VERSION).not_to be nil
  end
end
