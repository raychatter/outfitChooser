require 'sinatra'
require 'slim'

get '/' do
	slim :index
end

get '/add' do
	slim :add_clothing_item
end

post '/add' do
	"Added #{params[:clothing_type]} with description #{params[:clothing_description]} to category #{assign_clothing_category(params[:clothing_type])}."
end

private
	def assign_clothing_category(clothing_type)
		case clothing_type
			when 'sweater', 'button_up', 'tshirt', 'tank_top'
				return 'top'
			when 'shorts', 'pants'
				return 'bottom'
			when 'shoes'
				return 'shoes'
		end
	end
