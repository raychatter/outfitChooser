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
	property :neutral,		Boolean, default: false
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
	has n, :colors, through: :itemColors
	has 1, :category, through: :type

	def get_colors(main_color)
		return self.itemColors(main_color: main_color)
	end
end

class ItemColor
	include DataMapper::Resource
	property :id,					Serial
	property :main_color,	Boolean
	belongs_to :item
	belongs_to :color
end

DataMapper.finalize
Seed.reset_all

get '/' do
	slim :index
end

post '/' do
	@top, @bottom, @shoe = generate_outfit
	slim :index
end

get '/add' do
	@types = Type.all
	@colors = Color.all
	slim :add_clothing_item
end

post '/add' do
	# TODO: Verify valid input before loading to DB
	# TODO: Check to make sure success adding to DB, otherwise handle error
	item = Item.create(description: params[:clothing_description], type_id:params[:clothing_type])
	item.itemColors.create(main_color: true, color_id: params[:main_clothing_color])
	params[:additional_clothing_colors].each do |color_id|
		item.itemColors.create(main_color: false, color_id: color_id)
	end
	flash[:info] = "Item successfully added."
	redirect to('/add')
end

# private
	def generate_outfit
		######################################
		##### PRIMITIVE OUTFIT ALGORITHM #####
		######################################
		# 1. Pick a random pair of shoes
		# 	A. If shoe color is neutral, pick a random top.
		# 	B. Otherwise, pick a top that contains the main_color of the shoes.
		# 2. Pick a pair of pants at random that does not contain the main_color of the shirt 
		top = nil
		bottom = nil
		shoe = Item.all(type: {name:"shoes"}).sample
		main_shoe_color = shoe.itemColors(main_color:true).color.first
		top_type = Type.all(category: {name:"top"}).sample
		if(main_shoe_color.neutral)
			top = Item.all(type: top_type).sample
		else
			# TODO: FIX! This can hang... Maybe timeout?
			while(top.nil?)
				top = Item.all(type: top_type, itemColors: {main_color:true, color: main_shoe_color}).sample
				top_type = Type.all(category: {name:"top"}).sample	# GRRR
			end
		end
		# TODO: FIX! This can hang... Maybe timeout?
		while(bottom.nil?)
			bottom_type = Type.all(category: {name:"bottom"}).sample
			bottom = Item.all(type: bottom_type, itemColors: {main_color:true, :color.not => top.itemColors(main_color:true).color}).sample
		end

		return generate_item_hash(top), generate_item_hash(bottom), generate_item_hash(shoe)
	end

	def generate_item_hash(item)
		unless(item.nil?)
			return {obj: item, main_color: item.get_colors(true).first.color, other_colors: item.get_colors(false)}
		end
	end
