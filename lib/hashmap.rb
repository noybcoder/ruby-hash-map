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
  LOAD_FACTOR = 0.75

  def initialize
    @buckets = Array.new(16)
  end

  def hash(key)
    key.each_byte.reduce(0) { |hash_code, byte| 31 * hash_code + byte } % buckets.length
  end

  def set(key, value)
    index = hash(key)
    current = buckets[index]
    new_node = Node.new(key, value)
    replace(current, key, new_node) if current
    prepend(index, new_node)
  end

  def remove(key)
    index = hash(key)
    current = buckets[index]
    return if buckets[index].nil?
    while current.next_node
      current = nil if current.key == key
      current = current.next_node
    end
    buckets[index] = nil
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
map.set('a', 1000)
map.set('Q', 2)
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

map.expand
map.remove('Q')
map.print_hashmap
puts map.buckets.length
