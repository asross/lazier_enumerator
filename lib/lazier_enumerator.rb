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
    set = Set.new
    fn = block || ->(v) { v }
    select { |v| set.add?(fn.call(v)) }
  end
end
