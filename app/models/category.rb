Category = Struct.new(:id, :title) do

  def self.all
    @@all ||= [
      Category.new(0, "TITA PC"),
      Category.new(1, "TITO PC"),
      Category.new(2, "Device"),
    ]
  end

  def self.first
    self.all.first
  end

  def self.to_select
    @@categories_select ||= (
      categories = Category.all.clone
      categories.delete_at(0)
      categories.collect { |b| [b.title, b.id] }
    )
  end

  def self.find(id)
    return Category.first if id.nil?
    all.select { |b| b.id == id.to_i }.first
  end

end