# vim:set fileencoding=utf-8:

my_proc = Proc.new do |item|
  puts item
end

my_proc.call 1
# => 1

def proc_use_method item, my_proc
  my_proc.call item
end

proc_use_method 2, my_proc
# => 2


def proc_arg_method item, &arg_proc
  arg_proc.call item
end

proc_arg_method 4 do |item|
  puts item
end
# => 4


def yield_method item
  yield item
end

yield_method 8 do |item|
  puts item
end
# => 8


def wrapper_method file
  puts "open file"
  yield file
  puts "close file"
end

wrapper_method 16 do |file|
  puts "my file length is #{file}"
end
# =>
# open file
# my file length is 16
# close file
