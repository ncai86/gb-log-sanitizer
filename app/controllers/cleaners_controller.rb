require 'tempfile'

class CleanersController < ApplicationController

	CHECK_STRING = ['msg rcv', 'msg to send']

	def main
	end

	def process_file
		if params[:file].original_filename.include? '.txt'
			new_filename = params[:file].original_filename.sub(".txt", "_cleaned")
		else
			new_filename = params[:file].original_filename.sub(".log", "_cleaned")
		end
		
		@content = params[:file].read
		logger.info "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

		# File.open "#{Rails.root}/tmp/#{new_filename}.txt", 'wb', :output_encoding => "binary" do |file|
		file = Tempfile.new(["#{new_filename}", ".txt"], "tmp")
		file.binmode
		begin
			@content.each_line do |r|
				if  (r.include?('<#>') && include_string?(r, CHECK_STRING)) || ((r.include? '<#>') == false)
					# include_string?(r, CHECK_STRING )) || ((r.include? '<#>') == false)
					file.puts r
				end
			end
			file.close
			send_file file.path, :x_sendfile => true
		end
	end
	
	private

	def download(filename)
		send_file "#{Rails.root}/tmp/#{filename}.txt" 
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



