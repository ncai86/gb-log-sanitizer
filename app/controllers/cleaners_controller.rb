require 'tempfile'

class CleanersController < ApplicationController
	respond_to :js, :html

	CHECK_STRING = ['msg rcv', 'msg to send', 'EV.ERR']

	def main
	end

	def process_file
		if params[:file].original_filename.include? '.txt'
			new_filename = params[:file].original_filename.sub(".txt", "_cleaned.txt")
		else
			new_filename = params[:file].original_filename.sub(".log", "_cleaned.txt")
		end
		
		@content = params[:file].read
		logger.info "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

		# File.open "#{Rails.root}/tmp/#{new_filename}.txt", 'wb', :output_encoding => "binary" do |file|
		file = File.open("txlogs/#{new_filename}", "w+")
		file.binmode
		begin
			@content.each_line do |r|
				if  (r.include?('<#>') && include_string?(r, CHECK_STRING)) || ((r.include? '<#>') == false)
					# include_string?(r, CHECK_STRING )) || ((r.include? '<#>') == false)
					file.puts r
				end
			end
			file.close
			logger.info '#######################################'
			logger.info file.path
			@filepath = file.path
			@filename = new_filename
			respond_to do |format|
				format.js
			end
		end
	end

	def download
		logger.info params 
		logger.info "@@@@@@@@@@@@@@@@@@@@@@@@@@"
		send_file params[:filepath], :inline => false
	end

	private

	

	def include_string?(line, array)
		array.each do |string|
			if line.include? string
				return true
			end
		end
		return false
	end

end



