require 'minitest/autorun'
require 'minitest/pride'
require_relative '../enumerably'

describe Enumerably do
  it 'compactly' do
    [2,3].must_equal [nil,2,3].compactly.to_a
    [2,3].must_equal [1, 2, 3].map.compactly { |i| (i if i > 1) }
    [2,3].must_equal [nil,2,3].compactly.map { |i| i }
  end

  it 'uniquely' do
    [3].must_equal [-3,3].map.uniquely(&:abs)
    [3].must_equal [3,3].uniquely.map(&:itself)
    [0,1].must_equal [1,-1,2,-2].uniquely(:abs.to_proc).map { |i| i-1 }
  end

  it 'flatly' do
    [1,[1,2]].flatly.to_a.must_equal [1,1,2]
    [1,[1,2]].flatly.uniquely.to_a.must_equal [1,2]
    [1,[1,2]].uniquely.flatly.to_a.must_equal [1,1,2]
    [1,[2,[nil,3]]].flatly.compactly.to_a.must_equal [1,2,3]
    [1,[2,[nil,3]]].flatly.compactly { |i| (i if i == 3) }.must_equal [3]
    [1,[2,[nil,3,3]]].flatly.uniquely.compactly { |i| (i if i == 3) }.must_equal [3]
  end
end
