# vim:set fileencoding=utf-8:

def all? arr
  each_arr = arr.clone
  flag = true
  while item = each_arr.shift
    flag = flag && (yield item)
  end
  flag
end

ok = all? [1,2,4,5,5] do |item|
  item >= 0
end

no = all? [1,2,4,5,5] do |item|
  item == 0
end

p ok
p no
