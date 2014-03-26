require 'digest'
require 'base64'

module RecordsLib

  protected


  # Do DNS Query
  def query_dns records
    # record current fiber
    f = Fiber.current

    records = [records] if Record === records

    return [] if records.empty?

    resolver = RubyDNS::Resolver.new [ [:udp, "127.0.0.1", 53], [:tcp, "127.0.0.1", 53] ]

    length = records.size
    count = 0
    answers = []

    alldone = lambda do
      answers.sort!
      f.resume(answers)
    end

    records.each do |rec|
      resolver.query(rec.domain, Resolv::DNS::Resource::IN::ANY) do |response|
        count += 1
        if response.is_a? RubyDNS::Message and response.rcode == Resolv::DNS::RCode::NoError
          answers += response.answer.map{|r| RecordWrapper.new rec.id, r}
        end
        alldone.call if count == length
      end
    end

    # setup finished, pause current fiber & wait callback to resume
    Fiber.yield
  end

  # Do NSUPDATE
  # record => [ :method, domain, arg1, arg2, ... ]
  # records => [ record1, record2, ... ]
  def update_dns records
    f = Fiber.current

    zone = get_zone records[0][1]
    return false unless zone

    update = Dnsruby::Update.new zone

    records.each do |rec|
      return false unless rec[1].end_with? zone
      update.send *rec
    end

    update.set_tsig *BIND_UPDATE_KEY

    EventMachine.connect 'localhost', 53, NSUpdateConn, update.encode, proc { |response|
      f.resume response.rcode == Dnsruby::RCode::NOERROR
    }

    Fiber.yield
  end

  def get_zone record
    AVAILABLE_DOMAINS.each { |domain| return domain if record.end_with? domain }
    return nil
  end




  class NSUpdateConn < EventMachine::Connection
    def initialize query, callback
      @query, @callback = query, callback
    end

    def post_init
      send_data [@query.bytesize, @query].pack('na*')
    end

    def receive_data data
      answer = data.unpack('na*')
      if answer[1].bytesize == answer[0]
        @callback.call Dnsruby::Message.decode answer[1]
      else
        @callback.call nil
      end
    end
  end





  # ==== Class to wrap record
  class RecordWrapper
    IN = Resolv::DNS::Resource::IN
    
    attr_reader :id, :domain, :ttl, :type, :value
    def initialize rid, record
      @id = rid
      @domain = record[0].to_s
      @ttl = record[1]
      @type = type_to_symbol record[2]
      @value = extract_val record[2]
    end

    def type_to_symbol record
      case record
      when IN::A
        :A
      when IN::AAAA
        :AAAA
      when IN::CNAME
        :CNAME
      when IN::NS
        :NS
      when IN::MX
        :MX
      when IN::TXT
        :TXT
      when IN::SRV
        :SRV
      else
        :UNKNOWN
      end
    end

    def extract_val record
      case record
      when IN::A, IN::AAAA
        record.address.to_s
      when IN::CNAME, IN::NS
        record.name.to_s
      when IN::MX
        [record.preference, record.exchange.to_s].inspect
      when IN::TXT
        record.strings.inspect
      when IN::SRV
        [record.priority, record.weight, record.port, record.target.to_s].inspect
      else
        nil
      end
    end

    def hash
      hash_base = "#{@domain.downcase}|#{@type.to_s.upcase}|#{@value.inspect}"
      Base64.urlsafe_encode64(Digest::MD5.digest(hash_base)[4...10])
    end

    def <=> o
      return nil unless self.class === o
      s = @domain <=> o.domain
      return s unless s == 0
      s = @type <=> o.type
      return s unless s == 0
      return @value <=> o.value
    end

    def self.model_name
      Record.model_name
    end
  end
end

