require 'tempfile'

class CleanersController < ApplicationController
	respond_to :js, :html

	CHECK_STRING = ['msg rcv', 'msg to send', 'EV.ERR']

	def main
	end

	def process_file
		logger.info params[:file].class
		new_filename = sanitize_filename(params[:file])
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

	def sanitize_filename(file)
		stripped_file = file.original_filename

		if stripped_file.include? '.txt'
			stripped_file.sub(".txt", "_cleaned.txt")
		else
			stripped_file.sub(".log", "_cleaned.txt")
		end
	end


	def include_string?(line, array)
		array.each do |string|
			if line.include? string
				return true
			end
		end
		return false
	end

end



