require "open-uri"
require "nokogiri"

class ImageGraber
  def self.grab_images(url, dest_dir, tcount = 1)
    images = page_images(url)
    thread_count = tcount

    images_parts = data_parts(images, thread_count)

    threads = images_parts.map do |urls|
      Thread.new { save_images(urls, dest_dir) }
    end

    threads.each &:join
  end

  def self.page_images(url)
    Nokogiri::HTML(open(url.to_s)).xpath("//img/@src").map do |img|
      URI.join(url, img).to_s
    end
  end

  def self.save_images(urls, dest_dir)
    urls.each do |image_url|
      begin
        File.open("#{dest_dir}/#{File.basename(image_url)}", "wb") do |f|
          f.write(open(image_url).read)
        end
      rescue => e
        puts "Don't save file: #{image_url} #{e.message}"
      end
    end
  end

  def self.data_parts(data, parts_count)
    if data.count < parts_count
      return [data]
    else
      part_size = (data.count / parts_count).ceil
      data.each_slice(part_size)
    end
  end
end

if __FILE__ == $0
  url = ARGV[0]
  dest_dir = ARGV[1]

  ImageGraber::grab_images(url, dest_dir, 12)
end
