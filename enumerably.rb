require 'set'

module Enumerably
  def self.selective_enumerator(enumerable, if_proc, &block)
    real_enum = enumerable.each
    Enumerator.new do |yielder|
      loop do
        value = real_enum.next
        value = yield(value) if block_given?
        yielder << value if if_proc.call(value)
      end
    end
  end

  def self.flat_enumerator(enumerable, &block)
    real_enum = enumerable.each
    Enumerator.new do |yielder|
      loop do
        value = real_enum.next
        if value.is_a?(Enumerable)
          flat_enumerator(value, &block).each { |v| yielder << v }
        else
          value = yield(value) if block_given?
          yielder << value
        end
      end
    end
  end

  def self.compact_enumerator(enumerable, &block)
    not_nil = ->(v) { !v.nil? }
    selective_enumerator(enumerable, not_nil, &block)
  end

  def self.unique_enumerator(enumerable, by=->(v){v}, &block)
    set = Set.new
    is_uniq = ->(v){ set.add?(by.call(v)) }
    selective_enumerator(enumerable, is_uniq, &block)
  end
end

module Enumerable
  def compactly(&block)
    enumerably(:compact, &block)
  end

  def uniquely(by_proc=->(v){v}, &block)
    enumerably(:unique, by_proc, &block)
  end

  def flatly(&block)
    enumerably(:flat, &block)
  end

  def selectively(if_proc, &block)
    enumerably(:selective, condition, &block)
  end

  private def enumerably(type, *args, &block)
    enum = Enumerably.send(:"#{type}_enumerator", self, *args, &block)
    block_given?? enum.to_a : enum
  end
end
