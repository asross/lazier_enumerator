require 'minitest/autorun'
require 'minitest/pride'
require 'lazier_enumerator'

describe Enumerator::Lazy do
  it 'uniq' do
    [1,1,2,3,2].lazy.uniq.force.must_equal [1,2,3]
  end

  it 'compact' do
    [1,nil,2,3,nil].lazy.compact.force.must_equal [1,2,3]
  end

  it 'flatten' do
    [1,[2,3],[4]].lazy.flatten.force.must_equal [1,2,3,4]
  end

  it 'chains' do
    [1,nil,2,[3,4,[5,5,nil]]].lazy.
      flatten.compact.uniq.take(6).force.must_equal [1,2,3,4,5]
  end
end
