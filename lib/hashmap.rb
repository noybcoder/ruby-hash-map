# frozen_string_literal: true

# Hashmap class that represents the Hash Map data structure.
class HashMap
  # Inner class to represent a node in the hash map
  class Node
    # Allows the read and write access to the instance variables
    attr_accessor :key, :value, :next_node

    # Public: Initializes a new node.
    #
    # key - The key assigned to the new node (default: nil).
    # value - The data assigned to the new node (default: nil).
    # next_node - The pointer to the next node (default: nil).
    #
    # Returns a new Node object.
    def initialize(key = nil, value = nil, next_node = nil)
      @key = key # Assign the key
      @value = value # Assign the value
      @next_node = next_node # Assign the pointer to the next node
    end
  end

  private_constant :Node # Makes the Node class private within HashMap
  attr_accessor :buckets # Attribute to keep track of the buckets of the hash map

  LOAD_FACTOR = 0.75 # Sets the load factor as a constant

  # Public: Initializes a new hash map.
  #
  # Returns a new HashMap object.
  def initialize
    @buckets = Array.new(16) # The hash map initially contains 16 empty buckets
  end

  # Public: Computes a hash code for the given key
  #
  # key - The key to be hashed.
  # buckets - The array of buckets to compute the index for (default: self.buckets).
  #
  # Returns the index in the buckets array.
  def hash(key, buckets = self.buckets)
    # Calculate hash code by iterating over each byte in the key
    key.each_byte.reduce(0) { |hash_code, byte| 31 * hash_code + byte } % buckets.length
  end

  # Public: Inserts a key-value pair into the hash map.
  #
  # key - The key to be inserted.
  # value - The value to be associated with the key.
  def set(key, value)
    rehash if length >= LOAD_FACTOR * buckets.length # Rehash if the load factor is exceeded
    index = hash(key) # Compute the index for the key
    current = buckets[index] # Set the head node for traversal
    return if replace(current, key, value) # Replace the value if the key already exists

    new_node = Node.new(key, value, buckets[index]) # Create a new node
    buckets[index] = new_node # Insert the new node at the computed index
  end

  # Returns all entries (key-value pairs) in the hash map.
  #
  # Returns an array of key-value pairs.
  def entries
    buckets.compact.each_with_object([]) do |current, output|
      while current
        output << [current.key, current.value] # Add each node's key and value to the output
        current = current.next_node # Move to the next node in the chain
      end
    end
  end

  # Public：Retrieves the value for a given key.
  #
  # key - The key to search for.
  #
  # Returns the value associated with the key, or nil if not found.
  def get(key)
    entries.select { |pair| pair[0] == key }.flatten[1] # Find the value associated with the key
  end

  # Public: Checks if the hash map contains a given key.
  #
  # key - The key to search for.
  #
  # Returns true if the key exists, false otherwise.
  def has?(key)
    !!get(key) # Return true if the key exists, false otherwise
  end

  # Public: Returns all keys in the hash map.
  #
  # Returns an array of keys.
  def keys
    entries.map { |pair| pair[0] } # Extract keys from entries
  end

  # Public: Returns all values in the hash map.
  #
  # Returns an array of values.
  def values
    entries.map { |pair| pair[1] } # Extract values from entries
  end

  # Public: Removes a key-value pair from the hash map.
  #
  # key - The key to be removed.
  def remove(key)
    index = hash(key, buckets) # Compute the index for the key
    current = buckets[index] # Set the head node for traversal
    return if buckets[index].nil? # Return if the bucket is empty

    # Remove the node if it is the first node in the chain. Otherwise, remove the node in the chain
    buckets[index].key == key ? buckets[index] = current.next_node : skip_node(current, key)
  end

  # Public: Returns the number of key-value pairs in the hash map.
  #
  # Returns the length as an integer.
  def length
    entries.length
  end

  # Clears all key-value pairs from the hash map.
  def clear
    buckets.map! { |_bucket| nil }
  end

  private

  # Private: Replaces the value for a given key if it exists.
  #
  # current_node - The node to start searching from.
  # key - The key to search for.
  # value - The new value to be set.
  #
  # Returns true if the key was found and replaced, false otherwise.
  def replace(current_node, key, value)
    while current_node
      if current_node.key == key
        current_node.value = value # Update the value for the existing key
        return true
      end
      current_node = current_node.next_node # Move to the next node
    end
    false
  end

  # Private: Skips the node with a given key in the chain.
  #
  # current_node - The node to start searching from.
  # key - The key of the node to be removed.
  def skip_node(current_node, key)
    while current_node.next_node
      if current_node.next_node.key == key
        # Remove the node by skipping it
        current_node.next_node = current_node.next_node.next_node
        return
      end
      current_node = current_node.next_node # Move to the next node
    end
  end

  # Private: Rehashes the hash map to a new size.
  #
  # multiplier - The factor by which to increase the bucket size (default: 2).
  def rehash(multiplier = 2)
    new_buckets = Array.new(buckets.length * multiplier) # Create a new bucket array

    buckets.each do |bucket|
      while bucket
        index = hash(bucket.key, new_buckets) # Recompute the index for each node
        temp_node = Node.new(bucket.key, bucket.value, new_buckets[index]) # Create a new node
        new_buckets[index] = temp_node # Insert the node into the new bucket array
        bucket = bucket.next_node # Move to the next node
      end
    end
    self.buckets = new_buckets # Update the buckets with the new bucket array
  end
end
