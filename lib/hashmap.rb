class HashMap
  class Node
    attr_accessor :key, :value, :next_node

    def initialize(key=nil, value=nil, next_node=nil)
      @key = key
      @value = value
      @next_node = next_node
    end
  end

  private_constant :Node
  attr_accessor :buckets
  LOAD_FACTOR = 0.75

  def initialize
    @buckets = Array.new(16)
  end

  def hash(key, buckets)
    key.each_byte.reduce(0) { |hash_code, byte| 31 * hash_code + byte } % buckets.length
  end

  def set(key, value)
    index = hash(key, buckets)
    current = buckets[index]
    new_node = Node.new(key, value)
    replace(current, key, new_node) if current
    prepend(index, new_node)
  end

  def remove(key)
    index = hash(key, buckets)
    current = buckets[index]
    return if buckets[index].nil?
    buckets[index].key == key ? buckets[index] = current.next_node : skip_node(current, key)
  end

  def skip_node(current_node, key)
    while current_node.next_node
      break if current_node.next_node.key == key
      current_node = current_node.next_node
    end
    current_node.next_node = current_node.next_node.next_node
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

  def rehash(multiplier = 2)
    new_buckets = Array.new(buckets.length * multiplier)

    buckets.each do |bucket|
      while bucket
        index = hash(bucket.key, new_buckets)
        temp_node = Node.new(bucket.key, bucket.value, new_buckets[index])
        new_buckets[index] = temp_node
        bucket = bucket.next_node
      end
    end
    self.buckets = new_buckets
  end

  def entries; end

  def print_hashmap
    buckets.each_with_index do |current, idx|
      if current
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
map.set('Q', 2)
map.set('a', 1000)
map.set('A', 88)
map.set('b', 9999)
map.set('c', 888)
map.set('d', 888)
map.set('e', 888)
map.set('f', 888)
map.set('g', 888)
map.set('h', 888)
map.set('i', 888)
map.set('j', 888)
map.set('k', 888)
map.set('l', 888)
map.set('m', 888)
map.set('n', 888)
map.set('o', 888)
map.set('z', 1234)

map.rehash
map.remove('a')
map.print_hashmap
puts map.buckets.length
