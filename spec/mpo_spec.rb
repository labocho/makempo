require "spec_helper"

describe "Mpo" do
  let (:left_file_path) { "#{File.dirname(__FILE__)}/resources/l.jpg" }
  let (:right_file_path) { "#{File.dirname(__FILE__)}/resources/r.jpg" }
  let (:mpo_file_path) { "#{File.dirname(__FILE__)}/resources/expected.mpo" }
  it "should create MPO from 2 JPEGS" do
    created = Mpo.from_files(left_file_path, right_file_path)
    expected = File.read(mpo_file_path, encoding: "ascii-8bit")
    created.bytesize.should == expected.bytesize
    created.should == expected
  end
end
