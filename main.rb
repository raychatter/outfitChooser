require 'sinatra'
require 'slim'
require 'data_mapper'
require './seed'
require 'sinatra/flash'

enable :sessions

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Color
	include DataMapper::Resource
	property :id,					Serial
	property :name,				String, required: true
	has n, :itemColors, constraint: :destroy
end

class Category
	include DataMapper::Resource
	property :id,						Serial
	property :name,					String, required: true
	has n, :types, constraint: :destroy
end

class Type
	include DataMapper::Resource
	property :id,					Serial
	property :name,				String, required: true
	belongs_to :category
	has n, :items, constraint: :destroy
end

class Item
	include DataMapper::Resource
	property :id,						Serial
	property :description,	String, required: true
	belongs_to :type
	has n, :itemColors, constraint: :destroy
end

class ItemColor
	include DataMapper::Resource
	property :id,					Serial
	property :main_color,	Boolean
	belongs_to :item
	belongs_to :color
end

DataMapper.finalize

get '/' do
	slim :index
end

get '/add' do
	@types = Type.all
	@colors = Color.all
	slim :add_clothing_item
end

post '/add' do
	item = Item.create(description: params[:clothing_description], type_id:params[:clothing_type])
	item.itemColors.create(main_color: true, color_id: params[:main_clothing_color])
	params[:additional_clothing_colors].each do |color_id|
		item.itemColors.create(main_color: false, color_id: color_id)
	end
	flash[:info] = "Item successfully added."
	redirect to('/add')
end
