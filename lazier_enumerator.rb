require 'set'

class Enumerator::Lazy
  def flatten
    flat_map do |v|
      v.is_a?(Enumerable) ? v.lazy.flatten : v
    end
  end

  def compact
    reject(&:nil?)
  end

  def uniq(&block)
    seen = Set.new
    by = block_given? ? block : ->(v){v}
    select { |v| seen.add?(by.call(v)) }
  end
end
