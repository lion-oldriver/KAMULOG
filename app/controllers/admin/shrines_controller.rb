class Admin::ShrinesController < ApplicationController
  layout 'admin_application'
  before_action :authenticate_admin!

  def index
    @shrines = Shrine.includes(:shrine_gods, :gods, :shrine_tags, :tags).page(params[:page]).per(12)
  end

  def show
    @shrine = Shrine.find(params[:id])
    @near_shrine = @shrine.nearbys(20, units: :km)
    gon.shrine = @shrine
    gon.shrines = @near_shrine
    @posts = Post.where(shrine_id: @shrine.id).order(visit_date: :desc).includes(:user, :shrine, :post_images).page(params[:page]).per(8)
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
    shrine = Shrine.find(params[:id])
    shrine.destroy
    redirect_to admin_shrines_path
  end

  private

  def shrine_params
    params.require(:shrine).permit(:name, :address, :introduction, :latitude, :longitude, shrine_images_images: [])
  end
end
