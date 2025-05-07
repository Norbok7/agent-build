# frozen_string_literal: true

# Represents a single URL list
class List
  attr_reader :id, :custom_url, :urls, :owner_id

  def initialize(id:, custom_url:, owner_id: nil)
    @id = id
    @custom_url = custom_url
    @urls = []
    @owner_id = owner_id
  end

  def add_url(url)
    @urls << { id: SecureRandom.uuid, url: url }
  end

  def edit_url(url_id, new_url)
    item = @urls.find { |u| u[:id] == url_id }
    item[:url] = new_url if item
  end

  def delete_url(url_id)
    @urls.reject! { |u| u[:id] == url_id }
  end
end
