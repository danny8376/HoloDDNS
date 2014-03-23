require 'digest'
require 'base64'

module RecordsLib
  # with block
  def query_dns records
    # record current fiber
    f = Fiber.current

    #resolver = RubyDNS::Resolver.new( [ [:udp, "127.0.0.1", 53] ] )
    resolver = RubyDNS::Resolver.new( [ [:tcp, "127.0.0.1", 53] ] )

    length = records.size
    count = 0
    answers = []

    alldone = lambda do
      f.resume(answers)
    end

    records.each do |rec|
      resolver.query(rec.domain, Resolv::DNS::Resource::IN::ANY) do |response|
        count += 1
        if response.is_a? RubyDNS::Message and response.rcode == Resolv::DNS::RCode::NoError
          answers += response.answer
        end
        alldone.call if count == length
      end
    end

    # setup finished, pause current fiber & wait callback to resume
    Fiber.yield
  end


  # ==== Class to wrap record
  class RecordWrapper
    attr_reader :domain, :ttl, :type, :value
    def initialize record
      @domain = record[0].to_s
      @ttl = record[1]
      @type = type_to_symbol record[2]
      @value = extract_val record[2]
    end

    def type_to_symbol record
      case record
      when Resolv::DNS::Resource::IN::A
        :A
      when Resolv::DNS::Resource::IN::AAAA
        :AAAA
      when Resolv::DNS::Resource::IN::CNAME
        :CNAME
      when Resolv::DNS::Resource::IN::NS
        :NS
      when Resolv::DNS::Resource::IN::MX
        :MX
      when Resolv::DNS::Resource::IN::TXT
        :TXT
      when Resolv::DNS::Resource::IN::SRV
        :SRV
      else
        :UNKNOWN
      end
    end

    def extract_val record
      case record
      when Resolv::DNS::Resource::IN::A, Resolv::DNS::Resource::IN::AAAA
        record.address.to_s
      when Resolv::DNS::Resource::IN::CNAME, Resolv::DNS::Resource::IN::NS
        record.name.to_s
      when Resolv::DNS::Resource::IN::MX
        [record.preference, record.exchange.to_s].inspect
      when Resolv::DNS::Resource::IN::TXT
        record.strings.inspect
      when Resolv::DNS::Resource::IN::SRV
        [record.priority, record.weight, record.port, record.target.to_s].inspect
      else
        nil
      end
    end

    def hash
      hash_base = "#{@domain.downcase}|#{@type.to_s.upcase}|#{@value.inspect}"
      Base64.urlsafe_encode64(Digest::MD5.digest(hash_base)[4...10])
    end
  end
end
