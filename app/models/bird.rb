class Bird
  include Mongoid::Document
  field :name, type: String
  field :family, type: String
  field :continents, type:Array
  field :added, type:String, default: Time.now.to_s
  field :visible, type:Boolean, default: false
  validates_presence_of :name, :family, :continents
end
