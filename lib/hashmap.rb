require_relative 'linkedlist'

class HashMap
  attr_accessor :buckets

  def initialize
    @buckets = Array.new(16)
  end

  def hash(key, buckets=self.buckets)
    key.each_byte.reduce(0) { |hash_code, byte| 31 * hash_code + byte } % buckets.length
  end

  def set(key, value)
    index = hash(key)
    buckets[index] ||= LinkedList.new
    buckets.append(key, value)
  end
end


test = HashMap.new
test.set('a', 1)
test.set('b', 2)
p test
