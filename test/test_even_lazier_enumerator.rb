require 'minitest/autorun'
require 'minitest/pride'
require 'lazier_enumerator/even_lazier'

describe LazierEnumerator::EvenLazier do
  it 'lcompact' do
    [2,3].must_equal [nil,2,3].lcompact.to_a
    [2,3].must_equal [1, 2, 3].map.lcompact { |i| (i if i > 1) }
    [2,3].must_equal [nil,2,3].lcompact.map { |i| i }
  end

  it 'luniq' do
    [3].must_equal [3,3].luniq.to_a
    [3].must_equal [-3,3].map.luniq(&:abs)
    [0,1].must_equal [1,-1,2,-2].luniq(:abs.to_proc).map { |i| i-1 }
  end

  it 'lflatten' do
    [1,[1,2]].lflatten.to_a.must_equal [1,1,2]
    [1,[1,2]].lflatten.luniq.to_a.must_equal [1,2]
    [1,[1,2]].luniq.lflatten.to_a.must_equal [1,1,2]
    [1,[2,[nil,3]]].lflatten.lcompact.to_a.must_equal [1,2,3]
    [1,[2,[nil,3]]].lflatten.lcompact { |i| (i if i == 3) }.must_equal [3]
    [1,[2,[nil,3,3]]].lflatten.luniq.lcompact { |i| (i if i == 3) }.must_equal [3]
  end
end
