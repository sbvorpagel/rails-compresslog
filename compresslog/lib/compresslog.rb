require "compresslog/version"

module Compresslog
 	def backutp_is_needed?
 	 	dir = Dir.entries("#{Rails.root.join("log")}").grep /^#{Rails.env}.log./
 		!dir.empty?
	end

	def log_compress
  	data = Time.new.strftime("%Y%m%d_%H%M%S")

  	folder = Rails.root.join("log")
  	input_filenames = Dir.entries("#{folder}").grep /^#{Rails.env}.log./
  	zipfile_name = "#{folder}/#{data}.zip"

		Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
	    input_filenames.each do |filename|
	      zipfile.add(filename, "#{folder}/#{filename}")
	    end
	    zipfile.get_output_stream("README") { |os| os.write "O backup, dos logs, foi realizado com sucesso em: #{Time.now}" }
	  end

	  input_filenames.each do |i|
	    File.delete("#{folder}/#{i}")
	  end
	end
end
