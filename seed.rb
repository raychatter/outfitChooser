module Seed
	def self.reset_all
		self.delete_and_migrate_models
		self.seed_colors
		self.seed_categories
		self.seed_types
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
		colors = ['red', 'orange', 'yellow', 'green', 'blue', 'purple', 'black', 'white', 'brown', 'grey', 'pink']
		colors.each do |color|
			Color.create(name: color)
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
					['jacket', 'hoodie', 'cardigan', 'sweater', 'button-up', 'tshirt', 'tank top']
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

end