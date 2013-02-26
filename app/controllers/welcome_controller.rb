require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'
class WelcomeController < ApplicationController
  def index
  
  end

  def search
    doc = Nokogiri::HTML(open("http://d.yimg.com/aq/autoc?query=#{params[:q]}&region=IN&lang=en-IN&callback=YAHOO.util.ScriptNodeDataSource.callbacks"))
    text = doc.text
    actual_text = text[/#{Regexp.escape('[')}(.*?)#{Regexp.escape(']')}/m, 1]
    split_text = actual_text.split(/},/)
    @new_arr = []
    split_text.each_with_index do |x,index|
      x = x.to_s + '}' unless split_text.length == index+1
      x = JSON.parse(x)
      @new_arr << x
    end
    render :partial => "search"
  end

  def find_requested_data
    from_month,from_day,from_year = params[:from_date].split('/').map(&:to_i)
    from_month = from_month - 1
    to_month,to_day,to_year = params[:to_date].split('/').map(&:to_i)
    to_month = to_month - 1
    @csv = CSV.parse(open("http://ichart.yahoo.com/table.csv?s=#{params[:symbol]}&a=#{from_month}&b=#{from_day}&c=#{from_year}&d=#{to_month}&e=#{to_day}&f=#{to_year}&g=d&ignore=.csv"),{:headers => true,:return_headers => false})
    render :partial => "find_requested_data"
  end
end
