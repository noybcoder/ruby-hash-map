# frozen_string_literal: true

# Game class that represents the linked list data structure.
class LinkedList
  # Inner class to represent a node in the linked list
  class Node
    # Allows the read and write access to the instance variables
    attr_accessor :key, :value, :next_node

    # Public: Initializes a new node.
    #
    # value - The data assigned to the new node (default: nil).
    #
    # Returns a new Node object.
    def initialize(key = nil, value = nil, next_node = nil)
      @key = key
      @value = value # Assign the value
      @next_node = next_node # Set the pointer to the next node to nil
    end
  end

  private_constant :Node # Makes the Node class private within LinkedList
  attr_accessor :source # Attribute to keep track of the head of the list

  # Public: Initializes a new linked list.
  #
  # Returns a new LinkedList object.
  def initialize
    @source = nil # Initialize the linked list with no elements
  end

  # Public: Inserts a value to the end of the list.
  #
  # value - The data assigned to the new node.
  #
  # Returns nothing.
  def append(key, value)
    new_node = Node.new(key, value) # Create a new node
    if source.nil?
      self.source = new_node # If the list is empty, set the new node as the head
    else
      current = source # Assign the start of the list to a new variable for traversal
      current = current.next_node while current.next_node # Traverse to the end of the list
      current.next_node = new_node # Set the new node as the last node
    end
  end

  # Public: Inserts a value to the start of the list.
  #
  # value - The data assigned to the new node.
  #
  # Returns nothing.
  def prepend(key, value, next_node)
    new_node = Node.new(key, value, next_node) # Create a new node
    new_node.next_node = source # Set the new node to the start of the list
    self.source = new_node # Set the start of the list to the new node
  end

  # Public: Retrieves the size of the list.
  #
  # Returns the size of the list.
  def size
    current = source # Assign the start of the list to a new variable for traversal
    count = 0 # Set up the counter
    return count if source.nil? # Return 0 if the list is empty

    while current.next_node
      count += 1 # Increment counter by 1 for each traversal
      current = current.next_node # Set the current node to the next node
    end
    count += 1 # Increment counter by 1 to account for the last node
    count # Return the count
  end

  # Public: Retrieves the head of the list.
  #
  # Returns the head of the list.
  def head
    source
  end

  # Public: Retrieves the tail of the list.
  #
  # Returns the tail of the list.
  def tail
    return if source.nil? # Return nil if the list is empty

    current = source # Assign the start of the list to a new variable for traversal
    current = current.next_node while current.next_node # Traverse to the end of the list
    current # Return the last node
  end

  # Public: Retrieves the node at a specific position of the list.
  #
  # index - The specific position of the list.
  #
  # Returns the node at the specific index.
  def at(index)
    return if source.nil? # Return nil if the list is empty

    index %= size if index.between?(-size, size - 1) # Handle negative indices
    current = source # Assign the start of the list to a new variable for traversal
    index.times { current = current.next_node } # Traverse to the specified index
    current # Return the node at the specified index
  end

  # Public: Removes the last node of the list.
  #
  # Returns nothing.
  def pop
    return if source.nil? # Return nil if the list is empty

    current = source # Assign the start of the list to a new variable for traversal
    current = current.next_node while current.next_node.next_node # Traverse to the second to last node
    current.next_node = nil # Set the last node to nil
  end

  # Public: Checks if the list contains a specific value.
  #
  # value - The data to be found.
  #
  # Returns true if the value exists, false otherwise.
  def contains?(value)
    !!find(value)
  end

  # Public: Retrieves the index of the value in the list.
  #
  # value - The data to be found.
  #
  # Returns the index of the value in the list.
  def find(key)
    return if source.nil? # Return nil if the list is empty

    current = source # Assign the start of the list to a new variable for traversal
    index = 0 # Set the initial index to 0
    while current.next_node
      break if current.key == key # Break the loop when specific value is found

      current = current.next_node # Set the current node to the next node
      index += 1 # Increment the index by 1 if no match value is found
      # Set index to nil if no match value is found after the traversal
      index = nil unless current.key == key || current.next_node
    end
    index # Return the index
  end

  # Public: Returns a string representation of the list.
  #
  # Returns nothing.
  def to_s
    return if source.nil? # Return nil if the list is empty

    current = source # Assign the start of the list to a new variable for traversal
    while current.next_node
      print "( #{current.value} ) -> " # Print the value of the current node
      current = current.next_node # Move on to the next node
    end
    puts "( #{current.value} ) -> nil" # Print the value of the last node
  end

  # Public: Inserts a value to the specified position of the list.
  #
  # value - The value to be inserted into the list.
  #
  # Returns nothing.
  def insert_at(key, value, next_node, index)
    current = at(index - 1) # Traverse to the desired position of the list
    new_node = Node.new(key, value, next_node) # Create a new node
    new_node.next_node = current.next_node.next_node # Adds the new node to the desired position
    # Set the next node of the current node to the new node
    current.next_node = new_node
  end

  # Public: Removes a value from the specified position of the list.
  #
  # value - The value to be removed from the list.
  #
  # Returns nothing.
  def remove_at(index)
    current = at(index - 1) # Traverse to the desired position of the list
    # Set the next node of the current node to the node after
    current.next_node = current.next_node.next_node
  end
end
