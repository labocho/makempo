require "bindata"

module IFD_VALUE_TYPE
  LONG      = 0x0004
  RATIONAL  = 0x0005
  UNDEFINED = 0x0007
  SRATIONAL = 0x000A
end

class MPIndexIFD < BinData::Record
  endian :big

  # MP Index IFD
  uint16 :field_count, value: 3

  uint16 :mp_format_version_number_tag,   value: 0xB000
  uint16 :mp_format_version_number_type,  value: IFD_VALUE_TYPE::UNDEFINED
  uint32 :mp_format_version_number_count, value: 4
  string :mp_format_version_number_value, value: "0100"

  uint16 :number_of_images_tag,   value: 0xB001
  uint16 :number_of_images_type,  value: IFD_VALUE_TYPE::LONG
  uint32 :number_of_images_count, value: 1
  uint32 :number_of_images_value, value: 2

  uint16 :mp_entry_tag,    value: 0xB002
  uint16 :mp_entry_type,   value: IFD_VALUE_TYPE::UNDEFINED
  uint32 :mp_entry_count,  value: 2 * 16
  uint32 :mp_entry_offset, value: 0x32

  # Offset of Next IFD
  uint32 :offset_of_next_ifd, value: 0x52

  # MP Entry
  uint32 :individual_image_attribute_1, value: 0x20020002
  uint32 :indivisual_image_size_1 # SOI-EOI のサイズ
  uint32 :indivisual_image_data_offset_1, value: 0
  uint16 :dependent_image_1_entry_number_1, value: 0
  uint16 :dependent_image_2_entry_number_1, value: 0

  uint32 :individual_image_attribute_2, value: 0x00020002
  uint32 :indivisual_image_size_2 # SOI-EOI のサイズ
  uint32 :indivisual_image_data_offset_2 # :endian からこの画像の SOI へのオフセット
  uint16 :dependent_image_1_entry_number_2, value: 0
  uint16 :dependent_image_2_entry_number_2, value: 0
end

class MPAttributesIFD < BinData::Record
  endian :big

  uint16 :field_count, value: 4

  uint16 :mp_insivisual_image_number_tag, value: 0xB101
  uint16 :mp_insivisual_image_number_type, value: IFD_VALUE_TYPE::LONG
  uint32 :mp_insivisual_image_number_count, value: 1
  uint32 :mp_insivisual_image_number_value, value: 1

  uint16 :base_viewpoint_number_tag, value: 0xB204
  uint16 :base_viewpoint_number_type, value: IFD_VALUE_TYPE::LONG
  uint32 :base_viewpoint_number_count, value: 1
  uint32 :base_viewpoint_number_value, value: 1

  uint16 :convergence_angle_tag, value: 0xB205
  uint16 :convergence_angle_type, value: IFD_VALUE_TYPE::SRATIONAL
  uint32 :convergence_angle_count, value: 1
  uint32 :convergence_angle_offset, value: 0x88 # MP ヘッダから値へのオフセット

  uint16 :baseline_length_tag, value: 0xB206
  uint16 :baseline_length_type, value: IFD_VALUE_TYPE::RATIONAL
  uint32 :baseline_length_count, value: 1
  uint32 :baseline_length_offset, value: 0x90 # MP ヘッダから値へのオフセット

  uint32 :offset_of_next_ifd, value: 0

  # Values
  uint32 :convergence_angle_numerator, value: 0xFFFFFFFF
  uint32 :convergence_angle_denominator, value: 0xFFFFFFFF

  uint32 :baseline_length_numerator, value: 0xFFFFFFFF
  uint32 :baseline_length_denominator, value: 0xFFFFFFFF
end

class MPAttributesIFDForIndivisualImage < BinData::Record
  endian :big

  uint16 :field_count, value: 5

  uint16 :mp_format_version_tag, value: 0xB000
  uint16 :mp_format_version_type, value: IFD_VALUE_TYPE::UNDEFINED
  uint32 :mp_format_version_count, value: 4
  string :mp_format_version_value, value: "0100"

  uint16 :mp_insivisual_image_number_tag, value: 0xB101
  uint16 :mp_insivisual_image_number_type, value: IFD_VALUE_TYPE::LONG
  uint32 :mp_insivisual_image_number_count, value: 1
  uint32 :mp_insivisual_image_number_value, value: 2 # 2 枚目

  uint16 :base_viewpoint_number_tag, value: 0xB204
  uint16 :base_viewpoint_number_type, value: IFD_VALUE_TYPE::LONG
  uint32 :base_viewpoint_number_count, value: 1
  uint32 :base_viewpoint_number_value, value: 1

  uint16 :convergence_angle_tag, value: 0xB205
  uint16 :convergence_angle_type, value: IFD_VALUE_TYPE::SRATIONAL
  uint32 :convergence_angle_count, value: 1
  uint32 :convergence_angle_offset, value: 0x4A # MP ヘッダから値へのオフセット

  uint16 :baseline_length_tag, value: 0xB206
  uint16 :baseline_length_type, value: IFD_VALUE_TYPE::RATIONAL
  uint32 :baseline_length_count, value: 1
  uint32 :baseline_length_offset, value: 0x52 # MP ヘッダから値へのオフセット

  uint32 :offset_of_next_ifd, value: 0

  # Values
  uint32 :convergence_angle_numerator, value: 0xFFFFFFFF
  uint32 :convergence_angle_denominator, value: 0xFFFFFFFF

  uint32 :baseline_length_numerator, value: 0xFFFFFFFF
  uint32 :baseline_length_denominator, value: 0xFFFFFFFF
end

class App2 < BinData::Record
  string :marker, value: "\xFF\xE2"
  uint16be :field_length, value: 0x9E
  string :mp_format_identifier, value: "MPF\0"

  # MP Header
  string :mp_endian, value: "\x4D\x4D\x00\x2A" # Big Endian
  uint32be :offset_of_first_ifd, value: 8

  mp_index_ifd :mp_index_ifd

  mp_attributes_ifd :mp_attributes_ifd
end

class App2ForIndivisualImage < BinData::Record
  string :marker, value: "\xFF\xE2"
  uint16be :field_length, value: 0x60
  string :mp_format_identifier, value: "MPF\0"

  # MP Header
  string :mp_endian, value: "\x4D\x4D\x00\x2A" # Big Endian
  uint32be :offset_of_first_ifd, value: 8

  mp_attributes_ifd_for_indivisual_image :mp_attributes_ifd
end

# app2 = App2.new
# app2.mp_index_ifd.indivisual_image_size_1 = 0
# app2.mp_index_ifd.indivisual_image_size_2 = 0
# app2.mp_index_ifd.indivisual_image_data_offset_2 = 0

# open("app2.bin", "w"){|f| f.write app2.to_binary_s }

# app2i = App2ForIndivisualImage.new

# open("app2i.bin", "w"){|f| f.write app2i.to_binary_s }
