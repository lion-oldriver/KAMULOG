class Admin::ShrinesController < ApplicationController
  def index
    @shrines = Shrine.includes(:shrine_gods, :gods, :shrine_tags, :tags)
  end

  def show
    @shrine = Shrine.find(params[:id])
  end

  def edit
    @shrine = Shrine.find(params[:id])
    @shrine_tags = @shrine.tags.pluck(:tag_name).join(',')
    @shrine_gods = @shrine.gods.pluck(:god_name).join(',')
  end

  def update
    @shrine = Shrine.find(params[:id])
    tag_list = params[:shrine][:tag_name].split(',')
    god_list = params[:shrine][:god_name].split(',')
    if @shrine.update(shrine_params)
      @shrine.save_tag(tag_list)
      @shrine.save_god(god_list)
      redirect_to admin_shrine_path(@shrine)
    else
      redirect_to edit_admin_shrine_path(@shrine)
    end
  end

  def new
    @shrine = Shrine.new
  end

  def create
    @shrine = Shrine.new(shrine_params)
    tag_list = params[:shrine][:tag_name].split(',')
    god_list = params[:shrine][:god_name].split(',')
    if @shrine.save
      @shrine.save_tag(tag_list)
      @shrine.save_god(god_list)
      redirect_to admin_shrine_path(@shrine)
    else
      redirect_to new_admin_shrine_path
    end
  end

  def destroy
    @shrine = Shrine.find(params[:id])
    @shrine.destroy
    redirect_to admin_shrines_path
  end

  def search_tag
    @tag = Tag.find_by(tag_name: params[:tag_name])
    @shrines = @tag.shrine.includes(:shrine_gods, :gods, :shrine_tags, :tags)
  end


  private

  def shrine_params
    params.require(:shrine).permit(:name, :address, :introduction, :latitude, :longitude, shrine_images_images: [])
  end
end