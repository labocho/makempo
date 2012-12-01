require "makempo/version"

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
end
