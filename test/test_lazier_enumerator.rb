require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lazier_enumerator'

describe Enumerator::Lazy do
  it 'chains' do
    [1,nil,2,[3,4,[5,5,nil]]].lazy.
      flatten.compact.uniq.take(6).force.must_equal [1,2,3,4,5]
  end
end
