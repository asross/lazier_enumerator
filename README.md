# Lazier Enumerator / Enumerably

Expressions like this

```ruby
array.compact.uniq.map(&:uppercase)
```

iterate through the original `array` multiple times, when their actual goals
could be accomplished in one pass.

The normal Ruby way of doing this would be either an `each_with_object` or a
lazy enumerator, but both of those techniques are a bit verbose:

```ruby
# each_with_object way
already_seen = Set.new
array.each_with_object([]) do |el, array|
  if !el.nil? && already_seen.add?(el)
    array << el.uppercase
  end
end

# lazy way
already_seen = Set.new
array.lazy.
  reject(&:nil?).
  select { |el| already_seen.add?(el) }.
  map(&:uppercase).
  force
```

Instead, this library allows you to do:

```ruby
# lazier way
array.lazy.compact.uniq.map(&:uppercase).force

# even lazier way
array.compactly.uniquely.map(&:uppercase)
```

and much, much more by providing chainable lazy (and industrious) enumerators
for `compact`, `uniq`, and `flatten`.
