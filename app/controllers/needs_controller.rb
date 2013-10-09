class NeedsController < ApplicationController

  # GET /
  # GET /
  def index
    session[:needs] ||= {}
    @needs = session[:needs].sort {|a,b| b[0]<=>a[0]} #Need.all
    @need = Need.new
  end

  # POST /
  # POST /
  def create
    @need = Need.new(need_params)
    date = Time.now
    session[:needs].merge!( { "#{date.to_i}" =>
      {text: @need.text, date: date.strftime("%m.%d.%Y %H:%M"),
      competed: false} }) if @need.valid?
    
    respond_to do |format|
        format.js { @need = session[:needs]["#{date.to_i}"], date.to_i }
    end
  end

  # PATCH/PUT /needs/1
  # PATCH/PUT /needs/1.json
  def update
    if params[:complete] == 'true'
      session[:needs][params[:date]][:completed] = true
    elsif params[:complete] == 'false'
      session[:needs][params[:date]][:completed] = false
    else
      session[:needs][params[:date]][:text] = params[:text] unless params[:text].empty?
    end
    @need = {date: params[:date], text: params[:text], completed: params[:complete]}
    
    respond_to do |format|
        format.js { @need }
    end
  end

  # DELETE /1
  # DELETE /1.json
  def destroy
    if session[:user_id]
      #
    else
      session[:needs].delete(params[:need])
    end
    
    respond_to do |format|
      format.js { @date = params[:need] }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def need_params
      params.require(:need).permit(:text, :done)
    end
end
