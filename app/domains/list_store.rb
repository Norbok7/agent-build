# frozen_string_literal: true

require 'singleton'

# In-memory store for all lists
class ListStore
  include Singleton

  def initialize
    @lists = {}
  end

  def all(owner_id = nil)
    return @lists.values unless owner_id
    @lists.values.select { |l| l.owner_id == owner_id }
  end

  def find_by_id(id)
    @lists[id]
  end

  def find_by_custom_url(custom_url)
    @lists.values.find { |l| l.custom_url == custom_url }
  end

  def add(list)
    @lists[list.id] = list
  end

  def delete(id)
    @lists.delete(id)
  end
end
