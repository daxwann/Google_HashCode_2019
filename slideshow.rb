require_relative 'photo'
require "byebug"

class Slideshow
    attr_reader :filename, :photo_count, :file, :collection

    def initialize(filename)
        @filename = filename
        @file = File.open(filename)
        @photo_count = 0
        @collection = Array.new
        @new_collection = Array.new
    end

    def create_photos
        @photo_count = file.readline.chomp.to_i
        file.each.with_index do |line, idx|
            index = idx
            photo_format = /^[HV]/.match(line)
            total_tags = /^([HV]\s)(\d+)/.match(line)[2].to_i
            string = /^(\D*)(\d+)\s(.*)/.match(line)[3]
            tags = string.split(" ")
            @collection << Photo.new(index, photo_format, total_tags, tags)
        end
        @file.close
    end

    def sort_photos
        @collection = collection.sort_by do |photo|

            -photo.total_tags
        end
    end

    def output
        output = File.open("output.txt", "w")
        @new_collection.each do |photo|
            output << "#{photo.id}\n"
        end
        output.close
    end

    def link
        result = []
        first_photo = @new_collection.last
        puts first_photo.id
        first_photo.tags.each do |tag|
            similars = collection.select do |photo|
                photo.tags.include?(tag) && photo.id != first_photo.id
            end
            result += similars
        end
        @new_collection += result.uniq
        @new_collection.uniq!
    end

    def create_slideshow
        create_photos
        sort_photos
        @new_collection << collection.first
        until @new_collection.count >= 4 do
            link
            puts @new_collection.count
        end
        @new_collection += @collection
        @new_collection.uniq!
        output
    end
end


