require "stringio"

module Makempo
  class Jpeg
    SOI = "\xFF\xD8".force_encoding(Encoding::ASCII_8BIT) # Start Of Image
    SOS = "\xFF\xDA".force_encoding(Encoding::ASCII_8BIT) # Start of Scan
    EOI = "\xFF\xD9".force_encoding(Encoding::ASCII_8BIT) # End Of Image

    APP0 = "\xFF\xE0".force_encoding(Encoding::ASCII_8BIT) # JFIF
    APP1 = "\xFF\xE1".force_encoding(Encoding::ASCII_8BIT) # Exif
    APP2 = "\xFF\xE2".force_encoding(Encoding::ASCII_8BIT) # MPO

    class FormatError < StandardError; end
    class Segment
      attr_accessor :marker, :length, :body
      def to_s
        [marker, [length].pack("n"), body].join
      end

      def inspect
        "<Makempo::Jpeg::Segment marker: #{marker.dump} length: #{length}>"
      end
    end

    attr_accessor :raw, :image

    def self.load_file(path)
      jpeg = new
      jpeg.raw = File.read(path, encoding: "ascii-8bit")
      jpeg.parse
      jpeg
    end

    def segments
      @segments ||= []
    end

    # APP1 セグメントの直後に app2 を挿入する
    # APP1 セグメントが APP0 の直後、
    # それもなければ最初
    # すでに APP2 があれば置き換える
    def app2=(app2)
      case
      when index_of_app2 = segments.find_index{|s| s.marker == APP2}
        segments[index_of_app2] = app2
      when index_of_app1 = segments.find_index{|s| s.marker == APP1}
        segments.insert(index_of_app1 + 1, app2)
      when index_of_app0 = segments.find_index{|s| s.marker == APP0}
        segments.insert(index_of_app0 + 1, app2)
      else
        segments.insert(0, app2)
      end
    end

    def app2
      segments.find{|s| s.marker == APP2}
    end

    def parse
      @io = StringIO.new(@raw)
      raise FormatError unless @io.read(2) == SOI

      while true
        segment = Segment.new
        segment.marker = @io.read(2)
        segment.length = @io.read(2).unpack("n").first
        segment.body = @io.read(segment.length - 2)
        segments << segment
        break if segment.marker == SOS
      end

      image_buffer = ""
      while true
        image_buffer << @io.read(1)
        break if image_buffer[-2..-1] == EOI
      end
      @image = image_buffer[0..-3]
      self
    end

    def image_size
      @image.bytesize
    end

    def file_size
      to_s.bytesize
    end

    def mp_header_pos
      app2_pos = to_s =~ Regexp.new(APP2)
      app2_pos + 8
    end

    def to_s
      segments_s = segments.map{|s|
        if s.respond_to? :to_binary_s
          s.to_binary_s
        else
          s.to_s
        end
      }.join
      [SOI, segments_s, image, EOI].join
    end
  end
end
