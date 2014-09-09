class DomainValidator < ActiveModel::Validator
  def validate record
    fdomain = nil
    AVAILABLE_DOMAINS.each do |domain|
      if record.domain.end_with? domain
        fdomain = domain
        break
      end
    end
    unless fdomain
      record.errors[:domain] << "Invaild domain"
      return
    end
    sub = record.domain[0...-fdomain.size]
    record.errors[:domain] << "Invaild subdomain" unless sub.match /^[\w.-]+$/ # For SRV Record
    #record.errors[:domain] << "Invaild subdomain" unless sub.match /^[[:alnum:].-]+$/
    record.errors[:domain] << "Invaild subdomain length" unless (2..33).include? sub.size # 1~32
  end
end
