# vim:set fileencoding=utf-8:

def group_by arr
  hash = {}
  tmp_arr = arr.clone
  while item = tmp_arr.shift
    key = yield item
    hash[key] ||= []
    hash[yield(item)] <<  item
  end
  hash
end

even = group_by [1,2,3,4,5,6,7,8] do |n|
  n % 2
end

length = group_by ["siman", "kanpe", "innparusu", "atton"] do |name|
  name.size
end

p even
p length
