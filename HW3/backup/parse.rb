$root_path = "/home/vinzee/code/ml/cifar10_data/cifar-10-batches-bin/" 

def convert(file_name)
io = File.open($root_path + file_name + ".bin")
f = File.open($root_path + file_name + "_new.bin", "wb")
f.close

bytes = 0

while(bytes < 30730000) do
puts "bytes - #{bytes}"
binary_label = io.read(1)
label = binary_label.unpack("C")[0]
puts "label - #{label}"
image = io.read(3072)

if label == 2 || label == 7
f = File.open($root_path + file_name + "_new.bin", "ab")
binary_label = binary_label == 2 ? 0 : 1 
f.write([binary_label].to_s + image)
# f.write(binary_label + image)
f.close
end

bytes += 3073
end
end

convert("data_batch_1")
convert("data_batch_2")
convert("data_batch_3")
convert("data_batch_4")
convert("data_batch_5")


