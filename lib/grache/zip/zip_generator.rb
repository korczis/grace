# encoding: utf-8

require 'zip'

module Grache
  # This is a simple example which uses rubyzip to
  # recursively generate a zip file from the contents of
  # a specified directory. The directory itself is not
  # included in the archive, rather just its contents.
  #
  # Usage:
  # require /path/to/the/ZipFileGenerator/Class
  # directoryToZip = "/tmp/input"
  # outputFile = "/tmp/out.zip"
  # zf = ZipFileGenerator.new(directoryToZip, outputFile)
  # zf.write()

  class ZipGenerator
    # Initialize with the directory to zip and the location of the output archive.
    def initialize(inputDir, outputFile)
      @inputDir = inputDir
      @outputFile = outputFile
    end

    # Zip the input directory.
    def write(root = '')
      entries = Dir.entries(@inputDir)
      entries.delete('.')
      entries.delete('..')

      io = Zip::File.open(@outputFile, Zip::File::CREATE);
      writeEntries(entries, '', io, root)
      io.close();
    end

    # A helper method to make the recursion work.
    private

    def writeEntries(entries, path, io, root = '')
      entries.each { |e|
        zipFilePath = path == '' ? e : File.join(path, e)
        diskFilePath = File.join(@inputDir, zipFilePath)
        puts 'Deflating ' + diskFilePath

        if File.directory?(diskFilePath)
          io.mkdir(zipFilePath)

          subdir = Dir.entries(diskFilePath)
          subdir.delete('.')
          subdir.delete('..')

          writeEntries(subdir, zipFilePath, io)
        else
          iop = root.empty? ? zipFilePath : File.join(root, zipFilePath)
          # puts "IOP: #{iop}"
          io.get_output_stream(iop) do |f|
            f.print(File.open(diskFilePath, 'rb').read())
          end
        end
      }
    end
  end
end
