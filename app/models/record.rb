class Record < ActiveRecord::Base
  #belongs_to :user

  #validates_associated :user

  validates_with DomainValidator
end
