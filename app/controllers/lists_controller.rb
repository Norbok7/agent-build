# frozen_string_literal: true

class ListsController < ApplicationController
  VALID_CUSTOM_URL = /\A[a-zA-Z0-9_-]+\z/

  before_action :set_list, only: %i[show edit update destroy add_url edit_url delete_url]

  def index
    @lists = ListStore.instance.all(session[:user_id])
  end

  def show
  end

  def new
    @list = List.new(id: SecureRandom.uuid, custom_url: nil, owner_id: session[:user_id])
  end

  def create
    custom_url = params[:custom_url].to_s.strip.presence || generate_unique_url
    unless custom_url.match?(VALID_CUSTOM_URL)
      flash[:alert] = 'Custom URL can only contain letters, numbers, dashes, and underscores.'
      redirect_to new_list_path and return
    end
    if ListStore.instance.find_by_custom_url(custom_url)
      flash[:alert] = 'Custom URL already taken.'
      redirect_to new_list_path and return
    end
    @list = List.new(id: SecureRandom.uuid, custom_url: custom_url, owner_id: session[:user_id])
    ListStore.instance.add(@list)
    redirect_to list_path(@list.custom_url)
  end

  def edit
  end

  def update
    custom_url = params[:custom_url].to_s.strip.presence || @list.custom_url
    unless custom_url.match?(VALID_CUSTOM_URL)
      flash[:alert] = 'Custom URL can only contain letters, numbers, dashes, and underscores.'
      redirect_to edit_list_path(@list.custom_url) and return
    end
    if custom_url != @list.custom_url && ListStore.instance.find_by_custom_url(custom_url)
      flash[:alert] = 'Custom URL already taken.'
      redirect_to edit_list_path(@list.custom_url) and return
    end
    @list.instance_variable_set(:@custom_url, custom_url)
    flash[:notice] = 'List updated.'
    redirect_to list_path(@list.custom_url)
  end

  def destroy
    ListStore.instance.delete(@list.id)
    flash[:notice] = 'List deleted.'
    redirect_to lists_path
  end

  def add_url
    if params[:url].present?
      @list.add_url(params[:url])
      flash[:notice] = 'URL added.'
    else
      flash[:alert] = 'URL cannot be blank.'
    end
    redirect_to list_path(@list.custom_url)
  end

  def edit_url
    if params[:url_id].present? && params[:new_url].present?
      @list.edit_url(params[:url_id], params[:new_url])
      flash[:notice] = 'URL updated.'
    else
      flash[:alert] = 'URL cannot be blank.'
    end
    redirect_to list_path(@list.custom_url)
  end

  def delete_url
    if params[:url_id].present?
      @list.delete_url(params[:url_id])
      flash[:notice] = 'URL deleted.'
    end
    redirect_to list_path(@list.custom_url)
  end

  private

  def set_list
    @list = ListStore.instance.find_by_custom_url(params[:id]) || ListStore.instance.find_by_id(params[:id])
    redirect_to lists_path, alert: 'List not found.' unless @list
  end

  def generate_unique_url
    loop do
      url = SecureRandom.hex(4)
      break url unless ListStore.instance.find_by_custom_url(url)
    end
  end
end
