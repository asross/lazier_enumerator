require 'minitest/autorun'
require 'minitest/pride'
require 'lazier_enumerator/even_lazier'

describe LazierEnumerator::EvenLazier do
  it 'lcompact' do
    [2,3].must_equal [nil,2,3].lcompact.to_a
    [2,3].must_equal [nil,2,3].lcompact.map { |i| i }
    [2,3].must_equal [1,2,3].map.lcompact { |i| (i if i > 1) }
  end

  it 'luniq' do
    [3].must_equal [3,3].luniq.to_a
    [3].must_equal [-3,3].map.luniq(&:abs)
    [0,1].must_equal [1,-1,2,-2].luniq(:abs).map { |i| i-1 }
  end

  it 'lmap' do
    [1,2,3,4].must_equal [0,-1,2,-3].lmap(:abs).map { |i| i + 1 }
  end

  it 'lselect' do
    [2,4].must_equal [1,2,3,4].lselect(:odd?).map { |i| i + 1 }
  end

  it 'lreject' do
    [3,5].must_equal [1,2,3,4].lreject(:odd?).map { |i| i + 1 }
  end

  it 'lflatten' do
    [1,1,2].must_equal [1,[1,2]].lflatten.to_a
    [1,2].must_equal [1,[1,2]].lflatten.luniq.to_a
    [1,1,2].must_equal [1,[1,2]].luniq.lflatten.to_a
    [1,2,3].must_equal [1,[2,[nil,3]]].lflatten.lcompact.to_a
    [3].must_equal [1,[2,[nil,3]]].lflatten.lcompact { |i| (i if i == 3) }
    [3].must_equal [1,[2,[nil,3,3]]].lflatten.luniq.
      lcompact { |i| (i if i == 3) }
  end
end
