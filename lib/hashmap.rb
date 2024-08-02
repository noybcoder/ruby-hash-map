class HashMap
  class Node
    attr_accessor :key, :value, :next_node

    def initialize(key=nil, value=nil)
      @key = key
      @value = value
      @next_node = nil
    end
  end

  private_constant :Node
  attr_accessor :buckets

  def initialize
    @buckets = Array.new(16)
  end

  def hash(key)
    key.each_byte.reduce(0) { |hash_code, byte| 31 * hash_code + byte } % buckets.length
  end

  def set(key, value, buckets)
    index = hash(key)
    new_node = Node.new(key, value)
    current = buckets[index]
    replace(current, key, new_node) if current
    prepend(index, new_node)
  end

  def prepend(index, new_node)
    new_node.next_node = buckets[index]
    buckets[index] = new_node
  end

  def replace(current_node, key, new_node)
    while current_node
      current_node = new_node if current_node.key == key
      current_node = current_node.next_node
    end
  end

  def rehash(multiplier)
    new_buckets = Array.new(buckets.length * multiplier)
    buckets.each { |bucket| new_buckets[hash(bucket.key)] = bucket if bucket }
    self.buckets = new_buckets
  end

  def expand
    rehash(2)
  end

  def shrink
    rehash(0.5)
  end


  def print_hashmap
    buckets.each_with_index do |current, idx|
      if current
      # current = buckets[index]
        while current.next_node
          puts "Index: #{idx} Key: #{current.key} => Value: #{current.value}"
          current = current.next_node
        end
        puts "Index: #{idx} Key: #{current.key} => Value: #{current.value}"
      end
    end
  end
end

map = HashMap.new
map.set('a', 1000, map.buckets)
map.set('Q', 2, map.buckets)
map.set('b', 9999, map.buckets)
# map.set('c', 888, map.buckets)
# map.set('d', 888, map.buckets)
# map.set('e', 888, map.buckets)
# map.set('f', 888, map.buckets)
# map.set('g', 888, map.buckets)
# map.set('h', 888, map.buckets)
# map.set('i', 888, map.buckets)
# map.set('j', 888, map.buckets)
# map.set('k', 888, map.buckets)
# map.set('l', 888, map.buckets)
# map.set('m', 888, map.buckets)
# map.set('n', 888, map.buckets)
# map.set('o', 888, map.buckets)

map.shrink
map.print_hashmap
puts map.buckets.length
