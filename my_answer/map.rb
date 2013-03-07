# vim:set fileencoding=utf-8:

def map arr
  map_arr = arr.clone
  ret_arr = []
  while item = map_arr.shift
    ret_arr << (yield item)
  end
  ret_arr
end

twice = map [1,2,3,4,5] do |n|
  n**2
end

half = map [1,2,3,4,5] do |n|
  n / 2
end

float = map [1,2,3,4,5] do |n|
  n.to_f
end

p twice
p half
p float
