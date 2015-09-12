require_relative "../src/grab.rb"

describe "ImageGraber" do
  let(:url) { "https://en.wikipedia.org/wiki/Mesoamerica" }
  let(:dest_dir) { Dir.mktmpdir("images") }

  describe ".grab_images" do
    let(:images_count) { ImageGraber::page_images(url).count }

    before(:each) { FileUtils.mkdir_p dest_dir }
    after(:each) { FileUtils.rm_r dest_dir }

    it "grab images" do
      ImageGraber::grab_images(url, dest_dir, 12)

      expect(Dir.glob("#{dest_dir}/*").count).to eq images_count
    end
  end
end
