class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!

  include RecordsLib

  # GET /records
  # GET /records.json
  def index
    records = current_user.records
    @recs = query_dns(records)#.reject{|r| r.type == :UNKNOWN}
  end

  # GET /records/1
  # GET /records/1.json
  def show
  end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  #def edit
  #end

  # POST /records
  # POST /records.json
  def create
    params = record_params
    domain = "#{params[:subdomain]}.#{params[:domain]}"
    @record = current_user.records.find_by(domain: domain)
    domain_exist = true
    invaild_input = false
    unless @record
      @record = current_user.records.create(domain: domain)
      domain_exist = false
    end
    nsupdate = gen_dns_update params

    if nsupdate.is_a? String
      invaild_input = true
      @record.errors[:base] = nsupdate
    end

    respond_to do |format|
      if not invaild_input and (domain_exist or @record.save) and (update_dns nsupdate)
        format.html { redirect_to @record, notice: 'Record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @record }
      else
        format.html { render action: 'new' }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  #def update
  #  respond_to do |format|
  #    if @record.update(record_params)
  #      format.html { redirect_to @record, notice: 'Record was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: 'edit' }
  #      format.json { render json: @record.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    recs = query_dns @record, true
    rec = recs[params[:hash]]
    if rec
      val = rec.value.is_a?(Array) ? rec.value.join(' ') : rec.value
      update_dns [:delete, rec.domain, rec.type.to_s, val]
    end
    @record.destroy if recs.size <= 1
    respond_to do |format|
      format.html { redirect_to records_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = current_user.records.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      p = params.require(:record).permit(:subdomain, :domain, :ttl, :type, :value)
    end
end
