class IndexController < ApplicationController
  # GET /
  # GET /
  def index
    if session[:user_id]
      redirect_to "/#{session[:user_name]}"
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
    @need = {date: params[:date]}
    if params[:complete] == 'true'
      need_state = session[:needs][params[:date]][:completed]
      session[:needs][params[:date]][:completed] = need_state ? false : true
      @need[:completed] = need_state ? 'false' : 'true'
    else
      session[:needs][params[:date]][:text] = params[:text] unless params[:text].empty?
      @need[:text] = session[:needs][params[:date]][:text]
    end
    
    respond_to do |format|
        format.js { @need }
    end
  end

  # DELETE /1
  # DELETE /1.json
  def destroy
    session[:needs].delete(params[:date])
    
    respond_to do |format|
      format.js { @date = params[:date] }
    end
  end
end
