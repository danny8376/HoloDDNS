class Record < ActiveRecord::Base
  include RecordsLib

  belongs_to :user

  validates_associated :user
  validates :domain, uniqueness: { case_sensitive: false }

  validates_with DomainValidator


  # dummy fields for form_for
  attr_reader :subdomain, :ttl, :type, :value

  def destroy
    update_dns [:delete, domain]
    super
  end
end
