module Fingers
  abstract class Printer
    abstract def print(msg : String)
    abstract def flush
  end

  abstract class Formatter
    abstract def format(hint : String, highlight : String, selected : Bool, offset : Tuple(Int32, Int32) | Nil)

    # The hint drawn in the columns before the captured text (hint_position
    # "before"); offset is the captured text within highlight. Formatters
    # without it draw the hint over the start, as format does.
    def format_before(hint : String, highlight : String, selected : Bool, offset : Tuple(Int32, Int32))
      format(hint: hint, highlight: highlight, selected: selected, offset: offset)
    end
  end
end
