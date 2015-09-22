module Seed
	def self.reset_all
		self.delete_and_migrate_models
		self.seed_colors
		self.seed_categories
		self.seed_types
		self.seed_items
	end

	def self.delete_and_migrate_models
		puts "DELETING: model data."
		puts "MIGRATING: models."
		Color.auto_migrate!
		Category.auto_migrate!
		Type.auto_migrate!
		Item.auto_migrate!
		ItemColor.auto_migrate!
		puts "COMPLETE: Deleting model data."
		puts "COMPLETE: Migrating models."
	end

	def self.seed_colors
		puts "SEEDING: Colors."
		puts ".....ADDING: Main colors."
		colors = ['red', 'orange', 'yellow', 'green', 'blue', 'purple', 'pink']
		neutral_colors = ['black', 'white', 'brown', 'grey']
		colors.each do |color|
			Color.create(name: color)
		end
		puts ".....ADDING: Neutral colors."
		neutral_colors.each do |color|
			Color.create(name: color, neutral: true)
		end
		puts "COMPLETE: Seeding colors."
	end

	def self.seed_categories
		puts "SEEDING: Categories."
		categories = ['hat', 'top', 'bottom', 'shoe']
		categories.each do |category|
			Category.create(name: category)
		end
		puts "COMPLETE: Seeding categories."
	end

	def self.seed_types
		puts "SEEDING: Types."
		categories = Category.all
		categories.each do |category|
			type_names = case category.name
				when 'hat'
					['hat']
				when 'top'
					# TODO: Support all later (maybe with weather API?)
					# ['jacket', 'hoodie', 'cardigan', 'sweater', 'button-up', 'tshirt', 'tank top']
					['button-up', 'tshirt']
				when 'bottom'
					['shorts', 'pants']
				when 'shoe'
					['shoes']
			end
			type_names.each do |type|
				Category.get(category.id).types.create(name:type)
			end
		end
		puts "COMPLETE: Seeding types."
	end

	def self.seed_items
		puts "SEEDING: Items."

		# Button-ups
		puts ".....ADDING: Button-ups."
		self.items_helper("Uniqlo pattern flannel", "button-up", "red")

		# Tshirts
		puts ".....ADDING: Tshirts."
		self.items_helper("Binary connect the dots robot", "tshirt", "white", "black")
		self.items_helper("RepChi logo", "tshirt", "grey", "black", "red")

		# Shorts
		puts ".....ADDING: Shorts"
		self.items_helper("Gay pool party", "shorts", "pink")
		self.items_helper("Topman", "shorts", "blue")
		self.items_helper("Booty ;)", "shorts", "black")
		self.items_helper("OG FKA", "shorts", "green")
		self.items_helper("Denimn", "shorts", "blue")
		# Pants
		puts ".....ADDING: Pants."
		self.items_helper("Man pants", "pants", "grey")
		self.items_helper("Man pants", "pants", "red")
		self.items_helper("Man pants", "pants", "black")
		self.items_helper("Girl pants", "pants", "red")
		self.items_helper("Girl khakis", "pants", "brown")
		self.items_helper("Girl favorite blue pants", "pants", "blue")
		self.items_helper("Girl pants", "pants", "green")
		self.items_helper("H&M man corduroys", "pants", "brown")

		# Shoes
		puts ".....ADDING: Shoes."
		self.items_helper("Sambas", "shoes", "black", "white", "brown")
		self.items_helper("Squishy Adidas", "shoes", "black", "white")
		self.items_helper("Bicycles!", "shoes", "white", "black")
		self.items_helper("Red high tops", "shoes", "red", "blue", "white", "grey", "brown")
		self.items_helper("Skater", "shoes", "grey", "white")

		puts "COMPLETE: Seeding items."
	end

	def self.items_helper(description, type, main_color, *other_colors)
		item = Item.create(description: description, type_id: Type.first(name: type).id)
		item.itemColors.create(main_color: true, color_id: Color.first(name: main_color).id)
		other_colors.each do |color|
			item.itemColors.create(main_color: false, color_id: Color.first(name: color).id)
		end
	end
end