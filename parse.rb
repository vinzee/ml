$root_path = "~/code/ml/cifar10_data/cifar-10-batches-bin/"

def convert(file_name)
  io = File.open($root_path + file_name + ".bin")

  File.open($root_path + "new/" + file_name + ".bin", "wb") do |f|
  bytes = 0

  while(true) do
    puts "bytes - #{bytes}"
    binary_label = io.read(1)
    return if binary_label.nil?
    label = binary_label.unpack("C")[0]
    image = io.read(3072)

    if label == 2 || label == 7
      binary_label = [binary_label == 2 ? 0 : 1].pack("C")
      f << binary_label
      puts "binary_label - #{label}"
      f << image
    end

    bytes += 3073
    end
    f.close
  end
end

convert("data_batch_1")
convert("data_batch_2")
convert("data_batch_3")
convert("data_batch_4")
convert("data_batch_5")
convert("test_batch")