# frozen_string_literal: true

require_relative 'lib/hashmap'

test = HashMap.new
test.set('Q', 2)
test.set('a', 1000)
test.set('A', 88)
test.set('b', 9999)
test.set('c', 888)
test.set('d', 888)
test.set('e', 888)
test.set('f', 888)
test.set('g', 888)
test.set('h', 888)
test.set('i', 888)
test.set('j', 888)
test.set('k', 888)
test.set('l', 888)
test.set('m', 888)
test.set('n', 888)
test.set('o', 888)
test.set('z', 1234)

test.remove('Q')
test.remove('A')

test.set('y', 'uu')
test.set('y', 'zz')

p test.entries
