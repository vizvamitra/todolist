class IndexController < ApplicationController
  # GET /
  # GET /
  def index
    if session[:user_id]
      redirect_to "/#{session[:user_id]}"
    else
      session[:needs] ||= {}
      @needs = session[:needs].sort {|a,b| b[0]<=>a[0]} #Need.all
    end
  end

  # POST /
  # POST /
  def create
    unless params[:text].empty?
      date = Time.now
      session[:needs].merge!( { "#{date.to_i}" =>
        {text: params[:text], date: date.strftime("%m.%d.%Y %H:%M"),
        competed: false} })
    end
    
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
    session[:needs].delete(params[:need])
    
    respond_to do |format|
      format.js { @date = params[:need] }
    end
  end
end
