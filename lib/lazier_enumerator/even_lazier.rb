require 'set'

module LazierEnumerator::EvenLazier
  def self.map_enumerator(enumerable, fn, &block)
    real_enum = enumerable.each

    Enumerator.new do |yielder|
      loop do
        value = fn.call(real_enum.next)
        value = yield(value) if block_given?
        yielder << value
      end
    end
  end

  def self.select_enumerator(enumerable, fn, &block)
    real_enum = enumerable.each

    Enumerator.new do |yielder|
      loop do
        value = real_enum.next
        value = yield(value) if block_given?
        yielder << value if fn.call(value)
      end
    end
  end

  def self.flat_enumerator(enumerable, &block)
    stack = [enumerable.each]

    next_value = ->() {
      raise StopIteration if stack.empty?
      begin
        stack.last.next
      rescue StopIteration
        stack.pop
        next_value.call()
      end
    }

    Enumerator.new do |yielder|
      loop do
        value = next_value.call()
        value = yield(value) if block_given?
        if value.is_a?(Enumerable)
          stack << value.each
        else
          yielder << value
        end
      end
    end
  end
end

module Enumerable
  def lflatten(&block)
    even_lazier(:flat, &block)
  end

  def lmap(fn, &block)
    even_lazier(:map, fn.to_proc, &block)
  end

  def lselect(fn, &block)
    even_lazier(:select, fn.to_proc, &block)
  end

  def lreject(fn, &block)
    not_fn = ->(v) { !fn.to_proc.call(v) }
    lselect(not_fn, &block)
  end

  def lcompact(&block)
    not_nil = ->(v) { !v.nil? }
    lselect(not_nil, &block)
  end

  def luniq(fn = ->(v) { v }, &block)
    set = Set.new
    not_previously_seen = ->(v) { set.add?(fn.to_proc.call(v)) }
    lselect(not_previously_seen, &block)
  end

  private def even_lazier(type, *args, &block)
    enum = LazierEnumerator::EvenLazier.send(:"#{type}_enumerator", self, *args, &block)
    block_given? ? enum.to_a : enum
  end
end
