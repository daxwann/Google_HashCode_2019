class Photo
    attr_reader :id, :photo_format, :total_tags, :tags

    def initialize(id, photo_format, total_tags, tags)
        @id = id
        @photo_format = photo_format
        @total_tags = total_tags
        @tags = tags
    end
end