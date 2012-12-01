require "makempo/version"
require "shellwords"
require "tmpdir"
require "fileutils"

module Makempo
  require "makempo/app2"
  require "makempo/jpeg"

  module_function
  def from_files(left_path, right_path)
    left = Jpeg.load_file(left_path)
    right = Jpeg.load_file(right_path)

    left.app2 = App2.new
    right.app2 = App2ForIndivisualImage.new

    left.app2.mp_index_ifd.indivisual_image_size_1 = left.file_size
    left.app2.mp_index_ifd.indivisual_image_size_2 = right.file_size
    left.app2.mp_index_ifd.indivisual_image_data_offset_2 = left.file_size - left.mp_header_pos

    left.to_s + right.to_s
  end

  def from_animation_gif(path)
    mpo = nil
    Dir.mktmpdir do |dir|
      # agif.gif -> splitted.gif.0 splitted.gif.1
      system "convert +adjoin #{path.shellescape} #{File.join(dir, "splitted.gif").shellescape}"

      # splitted.gif.0 -> l.gif
      # splitted.gif.1 -> r.gif
      lgif = File.join(dir, "splitted-0.gif")
      rgif = File.join(dir, "splitted-1.gif")

      # l.gif -> l.jpg
      # r.gif -> r.jpg
      ljpg = File.join(dir, "l.jpg")
      rjpg = File.join(dir, "r.jpg")
      system Shellwords.join(["convert", lgif, ljpg])
      system Shellwords.join(["convert", rgif, rjpg])

      # l.jpg, r.jpg -> out.mpo
      mpo = Makempo.from_files(ljpg, rjpg)
    end
    mpo
  end
end
