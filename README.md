# Lazier Enumerators [![Build Status](https://api.travis-ci.org/asross/lazier_enumerator.svg)](https://travis-ci.org/asross/lazier_enumerator)

This library adds support for `uniq`, `flatten`, and `compact` to Ruby 2.0's
[`Enumerator::Lazy`](http://ruby-doc.org/core-2.0.0/Enumerator/Lazy.html).

## Basic Usage

Instead of

```ruby
enumerable.flatten.compact.uniq.map(&:uppercase)
```

which would loop through the `enumerable` multiple times, you can do

```ruby
require 'lazier_enumerator'

enumerable.lazy.flatten.compact.uniq.map(&:uppercase).force
```

which will do the same thing, but lazily, only loading one element of
`enumerable` at a time and only looping through it once.

In practice, based on benchmarks of this library and `Enumerator::Lazy` itself,
for most enumerables lazy enumeration is actually ~2x slower than normal
enumeration -- so use this library with a grain of salt :)

## If you want something even lazier (and slower)

You can require `lazier_enumerator/even_lazier`, which will define additional
methods on `Enumerable` to provide lazy support for a variety of operations --
but in practice they take ~10x longer than their industrious versions.

```ruby
require 'lazier_enumerator/even_lazier'

# pass procs or symbols, not blocks, to lmap/lselect/lreject

[1,-2,[3,nil,[4]]].lflatten.lcompact.luniq.lmap(:abs).lselect(:even?).each do |i|
  puts i
end

# => 2 4
```
