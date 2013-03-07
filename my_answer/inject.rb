# vim:set fileencoding=utf-8:

def inject array, pool=0
  each_arr = array
  while item = array.shift
    pool = yield(pool, item)
  end
  pool
end

sum = inject [1,2,3,4,5] do |sum, n|
  sum + n
end

prod = inject [1,2,3,4,5], 1 do |prod, n|
  prod * n
end

miss_prod = inject [1,2,3,4,5] do |prod, n|
  prod * n
end

p sum
p miss_prod
p prod
