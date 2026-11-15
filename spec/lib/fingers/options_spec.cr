require "../../spec_helper"
require "../../../src/fingers/options"

describe Fingers::Options do
  it "accepts hint position before" do
    Fingers::Options.hint_position.valid?("before").should eq({true, "ok"})
    Fingers::Options.hint_position.valid?("middle")[0].should be_false
  end
end
