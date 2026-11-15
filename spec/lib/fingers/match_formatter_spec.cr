require "../../spec_helper"
require "../../../src/fingers/dirs"
require "../../../src/fingers/match_formatter"

def setup(
  hint_style : String = "#[hint]",
  highlight_style : String = "#[highlight]",
  hint_position : String = "left",
  selected_hint_style : String = "#[selected_hint]",
  selected_highlight_style : String = "#[selected_highlight]",
  selected : Bool = false,
  offset : Tuple(Int32, Int32) | Nil = nil,
  hint : String = "a",
  highlight : String = "yolo"
)
  formatter = Fingers::MatchFormatter.new(
    highlight_style: highlight_style,
    backdrop_style: "#[backdrop]",
    hint_style: hint_style,
    selected_highlight_style: selected_highlight_style,
    selected_hint_style: selected_hint_style,
    hint_position: hint_position,
    reset_sequence: "#[reset]"
  )

  formatter.format(hint: hint, highlight: highlight, selected: selected, offset: offset)
end

describe Fingers::MatchFormatter do
  context "when hint position" do
    context "is set to left" do
      it "places the hint on the left side" do
        result = setup(hint_position: "left")
        result.should eq("#[reset]#[reset]#[hint]a#[reset]#[highlight]olo#[reset]#[backdrop]")
      end
    end

    context "is set to right" do
      it "places the hint on the right side" do
        result = setup(hint_position: "right")
        result.should eq("#[reset]#[reset]#[highlight]yol#[reset]#[hint]a#[reset]#[backdrop]")
      end
    end
  end

  context "when a hint is selected" do
    it "selects the correct format" do
      result = setup(selected: true)
      result.should eq("#[reset]#[reset]#[selected_hint]a#[reset]#[selected_highlight]olo#[reset]#[backdrop]")
    end
  end

  context "when offset is provided" do
    it "only highlights at specified offset" do
      result = setup(offset: {1, 5}, highlight: "yoloyoloyolo", hint: "a")
      result.should eq("#[reset]#[backdrop]y#[reset]#[hint]a#[reset]#[highlight]loyo#[reset]#[backdrop]loyolo#[backdrop]")
    end
  end

  context "when offset is at the beginning" do
    it "only highlights at specified offset" do
      result = setup(offset: {0, 3}, highlight: "yolo", hint: "a")
      result.should eq("#[reset]#[reset]#[hint]a#[reset]#[highlight]ol#[reset]#[backdrop]o#[backdrop]")
    end
  end
  context "format_before" do
    formatter = Fingers::MatchFormatter.new(
      highlight_style: "#[fg=yellow]", backdrop_style: "#[bg=black,fg=white]",
      hint_style: "#[fg=yellow,bold]", selected_highlight_style: "#[fg=green]",
      selected_hint_style: "#[fg=green,bold]", hint_position: "before",
      reset_sequence: "#[reset]"
    )

    it "keeps the whole match after the hint" do
      formatter.format_before(hint: "a", highlight: "yolo", selected: false, offset: {0, 4})
        .should eq("#[reset]#[fg=yellow,bold]a#[reset]#[fg=yellow]yolo#[reset]#[bg=black,fg=white]#[bg=black,fg=white]")
    end

    it "takes the end of the text before a captured group" do
      formatter.format_before(hint: "a", highlight: "x: yolo", selected: false, offset: {3, 4})
        .should eq("#[reset]#[bg=black,fg=white]x:#[fg=yellow,bold]a#[reset]#[fg=yellow]yolo#[reset]#[bg=black,fg=white]#[bg=black,fg=white]")
    end
  end
end
