# vim:set fileencoding=utf-8:

def each arr
  each_arr = arr.clone
  while item = each_arr.shift
    yield item
  end
end

each [1,2,3,4,5] do |item|
  p item
end

puts

each [1,2,3,4,5] do |item|
  puts item
  puts "hoge"
end
