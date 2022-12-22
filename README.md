# Advent of Code 2022

## My workflow

I have in the repo `work.rb` and `input.txt`. I open the project in VS Code and hit Cmd+Shift+B. This will trigger the [build task](./.vscode/tasks.json) that runs a file watcher (`npm install --global onchange`) which will run the code whenever I save.

## Personal stats

```
      -------Part 1--------   -------Part 2--------
Day       Time  Rank  Score       Time  Rank  Score
 22   00:12:11    16     85   01:05:35    50     51
 21   00:03:40    58     43   00:46:38  1306      0
 20   00:21:52   232      0   00:25:10   162      0
 19   10:02:50  4817      0   10:15:00  3913      0
 18   00:09:57  1299      0   00:20:48   484      0
 17   00:32:49   283      0   00:51:56   244      0
 16   01:00:28   661      0   03:11:54  1150      0
 15   00:11:17   126      0   00:57:45  1126      0
 14   00:08:16    33     68   00:12:54    70     31
 13   00:14:20   415      0   00:16:36   207      0
 12   00:09:02   162      0   00:10:43   140      0
 11   00:12:35    83     18   00:27:59   446      0
 10   00:08:29   618      0   00:13:22   150      0
  9   00:05:39    30     71   00:18:52   326      0
  8   00:05:52   219      0   00:11:31   154      0
  7   00:05:35     8     93   00:13:12    62     39
  6   00:00:39     1    100   00:01:08     1    100
  5   00:06:59   123      0   00:07:28    77     24
  4   00:00:44     3     98   00:01:26     1    100
  3   00:01:04     4     97   00:03:56    25     76
  2   00:04:49   325      0   00:07:27   231      0
  1   00:01:00    44     57   00:01:30    26     75
```

## Day 1

```ruby
# Part 1
p $stdin.read.split(/\n\s*\n/).map{_1.split.map(&:to_i).sum}.max

# Part 2
p $stdin.read.split(/\n\s*\n/).map{_1.split.map(&:to_i).sum}.sort.reverse[0...3].sum

# Part 2 (improved)
p $stdin.read.split(/\n\s*\n/).map{_1.split.map(&:to_i).sum}.max(3).sum
```

## Day 2

```ruby
# Part 1
o = 0
$stdin.readlines.each do |l|
  opponent, me = l.split
  map = {
    'A' => :rock,
    'B' => :paper,
    'C' => :scissors,
    'X' => :rock,
    'Y' => :paper,
    'Z' => :scissors,
  }
  bonus = {
    :rock => 1,
    :paper => 2,
    :scissors => 3,
  }
  score = -> m, o {
    return 3 if m == o
    return 6 if (m == :rock && o == :scissors) || (m == :paper && o == :rock) || (m == :scissors && o == :paper)
    return 0
  }
  o += score[map[me], map[opponent]] + bonus[map[me]]
end
p o

# Part 2
o = 0
$stdin.readlines.each do |l|
  opponent, me = l.split
  map = {
    'A' => :rock,
    'B' => :paper,
    'C' => :scissors,
  }
  opponent_chooses = map[opponent]
  winning = {
    :rock => :paper,
    :paper => :scissors,
    :scissors => :rock,
  }
  losing = {
    :rock => :scissors,
    :paper => :rock,
    :scissors => :paper,
  }
  bonus = {
    :rock => 1,
    :paper => 2,
    :scissors => 3,
  }
  me_choose = case me
    when 'X'; losing[opponent_chooses]
    when 'Y'; opponent_chooses
    when 'Z'; winning[opponent_chooses]
  end
  score = -> m, o {
    return 3 if m == o
    return 6 if (m == :rock && o == :scissors) || (m == :paper && o == :rock) || (m == :scissors && o == :paper)
    return 0
  }
  o += score[me_choose, opponent_chooses] + bonus[me_choose]
end
p o
```

## Day 3

```ruby
# Part 1
p $stdin.readlines.map { |l|
  l[0...l.size/2].chars.uniq & l[l.size/2..-1].chars.uniq
}.flatten.map { |c|
  c.ord < 97 ? c.ord - 65 + 27 : c.ord - 97 + 1
}.sum

# Part 2
groups = $stdin.read.split.each_slice(3).map { |l|
  l[0].chars.uniq & l[1].chars.uniq & l[2].chars.uniq
}
p groups.map { |g|
  g[0].ord < 97 ? g[0].ord - 65 + 27 : g[0].ord - 97 + 1
}.sum

# Part 1 (improved)
input = $stdin.readlines.map(&:chomp)
items = input.map { |l| l[0...l.size/2].chars.uniq & l[l.size/2..-1].chars.uniq }.flatten
priorities = items.map { |i| i.ord < 97 ? i.ord - 65 + 27 : i.ord - 97 + 1 }
p priorities.sum

# Part 2 (improved)
input = $stdin.readlines.map(&:chomp)
items = input.each_slice(3).map { |l| l[0].chars & l[1].chars & l[2].chars }.flatten
priorities = items.map { |i| i.ord < 97 ? i.ord - 65 + 27 : i.ord - 97 + 1 }
p priorities.sum
```

## Day 4

```ruby
# Part 1
lines = $stdin.readlines
pairs = lines.map { |l| l.split(',').map { |r| r.split('-').map(&:to_i) } }
p pairs.count { |a, b| a[0] <= b[0] && a[1] >= b[1] || b[0] <= a[0] && b[1] >= a[1] }

# Part 2
lines = $stdin.readlines
pairs = lines.map { |l| l.split(',').map { |r| r.split('-').map(&:to_i) } }
p pairs.count { |a, b| (a[0]..a[1]).to_a & (b[0]..b[1]).to_a != [] }
```

<img width="923" alt="image" src="https://user-images.githubusercontent.com/193136/205475478-db94e4b0-e3d1-4857-8ade-d7066581aadf.png">

## Day 5

```ruby
a, b = $stdin.read.split(/\n\s*\n/)
lines = a.lines
size = (lines.last.size + 2) / 4
stacks = Array.new(size) { |i| lines.reverse.drop(1).map { |l| l[i * 4 + 1] }.join.strip.chars }
moves = b.scan(/move (\d+) from (\d+) to (\d+)/).map { |m| [m[0].to_i, m[1].to_i - 1, m[2].to_i - 1] }
moves.each do |n, from, to|
  stacks[to] += stacks[from].pop(n).reverse # Remove `.reverse` for part 2
end
p stacks.map(&:last).join
```

## Day 6

```ruby
# Change all occuurances of `4` to `14` for part 2.
data = $stdin.read
4.upto(data.size) do |i|
  if data[i - 4, 4].chars.uniq.size == 4
    p i
    break
  end
end

# Improved version
p gets.chars.each_cons(4).find_index { |c| c.uniq.size == 4 } + 4
```

<img width="924" alt="image" src="https://user-images.githubusercontent.com/193136/205834202-2903866b-d695-4e0a-852a-74fd417cee5b.png">

## Day 7

```ruby
require 'pathname'
@dir = Pathname.new('/')
@dirs = {}
@sizes = {}
@dirs[@dir] = 0
$stdin.readlines.each do |line|
  things = line.split
  if things[0] == '$'
    if things[1] == 'cd'
      if things[2] == '..'
        @dir = @dir.parent
      elsif things[2] == '/'
        @dir = Pathname.new('/')
      else
        @dir = @dir + things[2]
      end
    end
  elsif things[0] == 'dir'
    @dirs[@dir + things[1]] = 0
  else
    size, name = things
    size = size.to_i
    @sizes[@dir + name] = size
  end
end

# Part 1
s = 0
@dirs.keys.map do |dir|
  files = @sizes.select { |k, v| k.to_s.start_with?(dir.to_s + '/') }
  total = files.values.sum
  s += total if total <= 100000
end
p s

# Part 2
sizes = {}
@dirs.keys.map do |dir|
  files = @sizes.select { |k, v| k.to_s.start_with?(dir.to_s + '/') }
  total = files.values.sum
  sizes[dir] = total
end
capacity = 70000000
occupied = @sizes.values.sum
pp sizes.values.filter { |v| occupied - v <= capacity - 30000000 }.min

# Cleaned-up
require 'pathname'
@dir = Pathname.new('/')
@dirs = { @dir => true }
@sizes = {}
$stdin.each_line do |line|
  if line =~ /^\$ cd (.*)/
    @dir = $1 == '/' ? Pathname.new('/') : @dir + $1
  elsif line =~ /^dir (.*)/
    @dirs[@dir + $1] = true
  elsif line =~ /^(\d+) (.*)/
    @sizes[@dir + $2] = $1.to_i
  end
end
du = -> dir { @sizes.select { |k, v| k.to_s.start_with?(dir.to_s + '/') }.values.sum }

# Part 1
p @dirs.keys.map { |dir| du[dir] }.filter { |v| v <= 100000 }.sum

# Part 2
occupied = @sizes.values.sum
p @dirs.keys.map { |dir| du[dir] }.filter { |v| occupied - v <= 70000000 - 30000000 }.min
```

## Day 8

```ruby
p map = $stdin.each_line.map { |line| line.chomp.chars.map(&:to_i) }
height = map.size
width = map[0].size
height_of = -> i, j {
  return -1 if i < 0 || i >= height || j < 0 || j >= width
  map[i][j]
}

# Part 1
is_visible = -> i, j {
  h = height_of[i, j]
  (0...i).all? { |k| height_of[k, j] < h } ||
    (i + 1...height).all? { |k| height_of[k, j] < h } ||
    (0...j).all? { |k| height_of[i, k] < h } ||
    (j + 1...width).all? { |k| height_of[i, k] < h }
}
p (0...height).map { |i|
  (0...width).map { |j|
    is_visible[i, j] ? 1 : 0
  }.sum
}.sum

# Part 2
score = -> i, j {
  h = height_of[i, j]
  count = -> e {
    c = 0
    e.each do |x|
      c += 1
      break if x >= h
    end
    return c
  }
  a = count[(0...i).reverse_each.map { |k| height_of[k, j] }]
  b = count[(i + 1...height).map { |k| height_of[k, j] }]
  c = count[(0...j).reverse_each.map { |k| height_of[i, k] }]
  d = count[(j + 1...width).map { |k| height_of[i, k] }]
  a * b * c * d
}
p (0...height).map { |i|
  (0...width).map { |j|
    score[i, j]
  }.max
}.max

# Cleaned-up
p map = $stdin.each_line.map { |line| line.chomp.chars.map(&:to_i) }
height = map.size
width = map[0].size
height_of = -> i, j { map[i][j] }

# Part 1
is_visible = -> i, j {
  h = height_of[i, j]
  (0...i).all? { |k| height_of[k, j] < h } ||
    (i + 1...height).all? { |k| height_of[k, j] < h } ||
    (0...j).all? { |k| height_of[i, k] < h } ||
    (j + 1...width).all? { |k| height_of[i, k] < h }
}
p (0...height).map { |i| (0...width).count { |j| is_visible[i, j] } }.sum

# Part 2
score = -> i, j {
  h = height_of[i, j]
  count = -> e {
    c = 0
    e.each do |x|
      c += 1
      break if x >= h
    end
    return c
  }
  a = count[(0...i).reverse_each.map { |k| height_of[k, j] }]
  b = count[(i + 1...height).map { |k| height_of[k, j] }]
  c = count[(0...j).reverse_each.map { |k| height_of[i, k] }]
  d = count[(j + 1...width).map { |k| height_of[i, k] }]
  a * b * c * d
}
p (0...height).flat_map { |i| (0...width).map { |j| score[i, j] } }.max

# (DRY-ied up)
p map = $stdin.each_line.map { |line| line.chomp.chars.map(&:to_i) }
height = map.size
width = map[0].size
each_tree = (0...height).flat_map { |i| (0...width).map { [i, _1] } }

left = -> ((i, j)) { (0...j).reverse_each.map { [i, _1] } }
right = -> ((i, j)) { (j + 1...width).map { [i, _1] } }
up = -> ((i, j)) { (0...i).reverse_each.map { [_1, j] } }
down = -> ((i, j)) { (i + 1...height).map { [_1, j] } }
directions = [left, right, up, down]

height_of = -> ((i, j)) { map[i][j] }
heights = -> directions { directions.map(&height_of) }
rays = -> tree { directions.map { _1[tree] } }

# Part 1
is_visible = -> tree { -> ray { ray.map(&height_of).all? { _1 < height_of[tree] } } }
p each_tree.count { |a| rays[a].map(&is_visible[a]).any? }

# Part 2
score = -> tree { -> ray { ray.map(&height_of).slice_after { _1 >= height_of[tree] }.first&.count || 0 } }
p each_tree.map { |a| rays[a].map(&score[a]).inject(&:*) }.max
```

## Day 9

```ruby
x, y = 0, 0
snake = Array.new(1) { [0, 0] } # Change 1 to 9 for part 2
tail = { [0, 0] => 1 }
$stdin.each_line do |line|
  dir, dist = line.chomp.split
  dist.to_i.times do
    case dir
    when 'R'
      x += 1
    when 'L'
      x -= 1
    when 'U'
      y += 1
    when 'D'
      y -= 1
    end
    cx, cy = x, y
    snake.each do |s|
      sx, sy = s
      if (sx - cx).abs > 1 || (sy - cy).abs > 1
        sx += sx < cx ? 1 : sx > cx ? -1 : 0
        sy += sy < cy ? 1 : sy > cy ? -1 : 0
      end
      cx, cy = sx, sy
      s[0] = sx
      s[1] = sy
    end
    tail[snake[-1].dup] = 1
    # # Debugging code
    # (0..5).reverse_each do |i|
    #   (0..5).each do |j|
    #     idx = snake.index([j, i])
    #     print [i, j] == [y, x] ? 'H' : (idx ? idx + 1 : '.')
    #   end
    #   puts
    # end
    # puts
  end
end
p snake
p tail.size

# (Cleaned up)
Knot = Struct.new(:position)
rope = Array.new(2) { Knot.new([0, 0]) } # <-- (change 2 to 10 for part 2)
trail = { [0, 0] => 1 }
dirs = { 'R' => [1, 0], 'L' => [-1, 0], 'U' => [0, 1], 'D' => [0, -1] }
move = -> ((x, y), (dx, dy)) { [x + dx, y + dy] }
follow_1d = -> value, target { value + (value < target ? 1 : value > target ? -1 : 0) }
follow_2d = -> ((x, y), (tx, ty)) { (x - tx).abs > 1 || (y - ty).abs > 1 ? [follow_1d[x, tx], follow_1d[y, ty]] : [x, y] }
$stdin.each_line do |line|
  dir, dist = line.chomp.split
  dist.to_i.times do
    rope.first.position = move[rope.first.position, dirs[dir]]
    rope.each_cons(2) { |a, b| b.position = follow_2d[b.position, a.position] }
    trail[rope.last.position] = 1
  end
end
p trail.size
```

## Day 10

```ruby
# (Cleaned up code)
Val = Struct.new(:cycle, :x)
class Crt
  attr_accessor :x
  attr_reader :history
  def initialize
    @x = 1
    @cx = 0
    @output = []
    @history = {}
  end
  def cycle
    @history[@cx] = @x
    if (@cx % 40 - @x).abs <= 1
      @output << "#"
    else
      @output << "."
    end
    @cx += 1
  end
  def to_s
    @output.each_slice(40).map { |s| s.join }.join("\n")
  end
end

crt = Crt.new
$stdin.each_line do |line|
  if line =~ /addx (.+)/
    crt.cycle
    crt.cycle
    crt.x += $1.to_i
  elsif line =~ /noop/
    crt.cycle
  end
end

# Part 1
p [20, 60, 100, 140, 180, 220].sum { |i| crt.history[i - 1] * i }

# Part 2
puts crt.to_s
```

## Day 11

```ruby
$lcm = 1
$div_by = 3   # Change to 1 for part 2
$rounds = 20  # Change to 10000 for part 2
class Monkey
  def initialize(items, operation, test, if_true, if_false)
    @items = items
    @operation = operation
    @test = test
    @if_true = if_true
    @if_false = if_false
    @times = 0
    $lcm = $lcm.lcm(test)
  end
  attr_accessor :items
  attr_reader :times
  def inspect_items(monkeys)
    @items.map! do |worry_level|
      worry_level = @operation.call(worry_level) / $div_by
      worry_level %= $lcm
      if worry_level % @test == 0
        monkeys[@if_true].items << worry_level
      else
        monkeys[@if_false].items << worry_level
      end
      @times += 1
      nil
    end
    @items.compact!
  end
  def to_s
    @items.join(", ")
  end
end

# Monkey 0:
#   Starting items: 79, 98
#   Operation: new = old * 19
#   Test: divisible by 23
#     If true: throw to monkey 2
#     If false: throw to monkey 3
# Monkey 1:
#   Starting items: 54, 65, 75, 74
#   Operation: new = old + 6
#   Test: divisible by 19
#     If true: throw to monkey 2
#     If false: throw to monkey 0
# Monkey 2:
#   Starting items: 79, 60, 97
#   Operation: new = old * old
#   Test: divisible by 13
#     If true: throw to monkey 1
#     If false: throw to monkey 3
# Monkey 3:
#   Starting items: 74
#   Operation: new = old + 3
#   Test: divisible by 17
#     If true: throw to monkey 0
#     If false: throw to monkey 1  
monkeys = [
  Monkey.new([79, 98], -> o { o * 19 }, 23, 2, 3),
  Monkey.new([54, 65, 75, 74], -> o { o + 6 }, 19, 2, 0),
  Monkey.new([79, 60, 97], -> o { o * o }, 13, 1, 3),
  Monkey.new([74], -> o { o + 3 }, 17, 0, 1)
]

# (Paste the input in comments block and let Copilot generate the monkeys array)
# monkeys = []

$rounds.times do |i|
  monkeys.each do |m|
    m.inspect_items monkeys
  end
  p [i + 1, monkeys.map(&:times)]
end

puts monkeys.map(&:times).max(2).reduce(:*)
```

## Day 12

```ruby
map = $stdin.read.split.map(&:chars)
pos_list = (0...map.size).flat_map { |i| (0...map[i].size).map { |j| [i, j] } }
to_elevation = -> c {
  c = 'a' if c == 'S'
  c = 'z' if c == 'E'
  c.ord - "a".ord
}
start_pos_list = pos_list.select { |i, j| map[i][j] == "S" }
next_pos_list = -> i, j {
  [[i - 1, j], [i + 1, j], [i, j - 1], [i, j + 1]].select do |i2, j2|
    i2 >= 0 && i2 < map.size && j2 >= 0 && j2 < map[i].size && to_elevation[map[i2][j2]] <= to_elevation[map[i][j]] + 1
  end
}

# Comment for part 1
start_pos_list += pos_list.select { |i, j| map[i][j] == "a" }

end_pos = pos_list.find { |i, j| map[i][j] == "E" }
State = Struct.new(:pos, :steps)
choices = []
start_pos_list.each do |start_pos|
  queue = [State.new(start_pos, [start_pos])]
  visited = { start_pos => true }
  loop do
    state = queue.shift
    break if state.nil?
    pos = state.pos
    steps = state.steps
    next_pos_list[*pos].each do |pos2|
      if pos2 == end_pos
        choices << state.steps.size
        print '.'
        break
      end
      if !visited[pos2]
        visited[pos2] = true
        next_step = steps + [pos2]
        next_state = State.new(pos2, next_step)
        queue << next_state
      end
    end
  end
end
puts
p choices.min
```

## Day 13

```ruby
pairs = $stdin.read.split("\n\n").map { |x| x.lines.map { |y| eval y } }
compare = -> x, y {
  if x.is_a?(Array) && y.is_a?(Array)
    max_index = [x.size, y.size].max
    max_index.times do |i|
      a, b = x[i], y[i]
      return -1 if a.nil?
      return 1 if b.nil?
      c = compare[a, b]
      return c if c != 0
    end
    return 0
  elsif x.is_a?(Array) && !y.is_a?(Array)
    compare[x, [y]]
  elsif !x.is_a?(Array) && y.is_a?(Array)
    compare[[x], y]
  else
    x <=> y
  end
}

# Part 1
i = 0
sum = 0
pairs.each do |a, b|
  i += 1
  p [i, compare[a, b], a, b]
  sum += i if compare[a, b] < 0
end
puts "Part 1: #{sum}"

# Part 2
k = pairs.flatten(1)
k << [[2]]
k << [[6]]
cmp = k.sort{|a,b|compare[a,b]}
puts "Part 2: #{(cmp.index([[2]]) + 1) * (cmp.index([[6]]) + 1)}"
```

## Day 14

```ruby
paths = $stdin.readlines.map { |x| x.strip.split(' -> ').map { |y| y.split(',').map(&:to_i) } }
map = Hash.new('.')
paths.each do |path|
  path.each_cons(2) do |a, b|
    if a[0] == b[0]
      min, max = [a[1], b[1]].minmax
      (min..max).each do |y|
        map[[a[0], y]] = '#'
      end
    else
      min, max = [a[0], b[0]].minmax
      (min..max).each do |x|
        map[[x, a[1]]] = '#'
      end
    end
  end
end
floor = nil                          # Part 1
floor = map.keys.map(&:last).max + 2 # Part 2
map2 = -> c {
  x, y = c
  if y == floor
    '#'
  else
    map[[x, y]]
  end
}
sand = -> {
  x, y = 500, 0
  loop do
    if map2[[x, y + 1]] == '.'
      x, y = x, y + 1
    elsif map2[[x - 1, y + 1]] == '.'
      x, y = x - 1, y + 1
    elsif map2[[x + 1, y + 1]] == '.'
      x, y = x + 1, y + 1
    else
      break
    end
  end
  map[[x, y]] = 'o'
}
draw = -> {
  (0..map.keys.map(&:last).max + 2).each do |y|
    (map.keys.map(&:first).min .. map.keys.map(&:first).max).each do |x|
      print map2[[x, y]]
    end
    puts
  end
}

t = 0
loop do
  sand[]
  t += 1
  # draw[]
  p t
  break if map[[500, 0]] == 'o'
end

# In part 1, the program will go into an infinite loop.
# In part 2, the program will halt once exit condition is reached.
# Output is the last number printed.
```

## Day 15

```ruby
# Part 1
Report = Struct.new(:pos, :closest_beacon)
beacon_pos = {}
data = $stdin.readlines.map { |l|
  x1, y1, x2, y2 = l.scan(/(\d+)/).map(&:first).map(&:to_i)
  beacon_pos[[x2, y2]] = true
  Report.new([x1, y1], [x2, y2])
}
manhattan = -> (a, b) { (a[0] - b[0]).abs + (a[1] - b[1]).abs }
blast = -> (sensor, beacon, y) {
  distance = manhattan[sensor, beacon]
  y_diff = (sensor[1] - y).abs
  width = distance - y_diff
  return nil if width < 0
  (sensor[0] - width)..(sensor[0] + width)
}

y_search = 10
ranges = data.map { |r| blast[r.pos, r.closest_beacon, y_search] }.compact
p ranges
beacon_xs = beacon_pos.select { |k, v| k[1] == y_search }.keys.map(&:first)
p (ranges.map(&:to_a).flatten.uniq - beacon_xs).size
```

```ruby
# Part 2
Report = Struct.new(:pos, :closest_beacon)
beacon_pos = {}
sensor_pos = {}
beacon_on_y = {}
data = $stdin.readlines.map { |l|
  x1, y1, x2, y2 = l.scan(/(-?\d+)/).map(&:first).map(&:to_i)
  beacon_pos[[x2, y2]] = true
  sensor_pos[[x1, y1]] = true
  beacon_on_y[y2] ||= {}
  beacon_on_y[y2][x2] = true
  Report.new([x1, y1], [x2, y2])
}
manhattan = -> (a, b) { (a[0] - b[0]).abs + (a[1] - b[1]).abs }
blast = -> (sensor, beacon, y) {
  distance = manhattan[sensor, beacon]
  y_diff = (sensor[1] - y).abs
  width = distance - y_diff
  return nil if width < 0
  (sensor[0] - width)..(sensor[0] + width)
}
scan_range = -> (rs, xx, min = rs.map(&:begin).min, max = rs.map(&:begin).max) {
  events = []
  rs.each do |r|
    events << [r.begin, 1]
    events << [r.end + 1, -1]
  end
  events << [min, 0]
  events << [max, 0]
  events.sort_by!(&:first)
  last_x = 0
  count = 0
  active = false
  in_range = 0
  events.each do |x, delta|
    if active && in_range > 0
      count += x - last_x
    end
    in_range += delta
    if x == min
      active = true
    end
    if x == max
      break
    end
    last_x = x
  end
  count
}

(0..4000000).reverse_each do |y_search|
  ranges = data.map { |r| blast[r.pos, r.closest_beacon, y_search] }.compact + (beacon_on_y[y_search] || {}).keys.map { |x| x..x }
  scanned_count = scan_range[ranges, (beacon_on_y[y_search] || {}).keys, 0, 4000000]
  p [y_search, scanned_count]
  if scanned_count < 4000000
    xs = (0..4000000).to_a - ranges.map(&:to_a).flatten.uniq
    p xs[0] * 4000000 + y_search
    break
  end
  # puts (0..20).map { |x| sensor_pos[[x, y_search]] ? 'S' : beacon_pos[[x, y_search]] ? 'B' : xs.include?(x) ? '.' : '#' }.join('')
end
```

## Day 16

<details><summary>Scrappy part 1</summary>

```ruby
# Part 1
Valve = Struct.new(:name, :flow_rate, :tunnels)
valves = $stdin.read.scan(/Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/).map do |name, flow_rate, tunnels|
  Valve.new(name, flow_rate.to_i, tunnels.split(', '))
end
$valve_map = valves.map { |v| [v.name, v] }.to_h

# Find shortest path from a given valve
shortest_path = -> from {
  visited = {}
  queue = [[from, 0]]
  while !queue.empty?
    current, distance = queue.shift
    next if visited[current]
    visited[current] = distance
    $valve_map[current].tunnels.each do |tunnel|
      queue << [tunnel, distance + 1]
    end
  end
  visited
}
$shortest_paths = valves.map { |v| [v.name, shortest_path[v.name]] }.to_h
$valves_worth_opening = valves.select { |v| v.flow_rate > 0 }

fridge = []
State = Struct.new(:time, :opened, :current, :cost, :released) do
  def next_states
    out = []
    # Opportunity cost = unopened valves
    release = opened.sum { |name, opened| opened ? $valve_map[name].flow_rate : 0 }
    opportunity_cost = $valves_worth_opening.filter { |v| !opened[v.name] }.sum(&:flow_rate)
    # Do nothing
    time_remaining = 30 - time
    if time_remaining > 0
      out << State.new(
        time + time_remaining,
        opened,
        current,
        cost + opportunity_cost * time_remaining,
        released + release * time_remaining
      )
    end
    # Open a valve
    $valves_worth_opening.each do |valve|
      next if opened[valve.name]
      elapsed = $shortest_paths[current][valve.name] + 1
      target_time = time + elapsed
      next if target_time > 30
      out << State.new(
        target_time,
        opened.merge(valve.name => true),
        valve.name,
        cost + opportunity_cost * elapsed,
        released + release * elapsed
      )
    end
    out
  end
  def key
    @key ||= [time, opened, current]
  end
end
fridge << State.new(0, {}, 'AA', 0, 0)
visited = {}
last_time = 0
while !fridge.empty?
  fridge.sort_by! { |s| s.cost }
  state = fridge.shift
  key = state.key
  next if visited[key]
  visited[key] = true
  if Time.now.to_f - last_time > 1
    p [state.time, state.released, state.cost, state]
    last_time = Time.now.to_f
  end
  if state.time == 30
    puts state.released
    exit
  end
  fridge += state.next_states.reject { |s| visited[s.key] }
end
```

</details>

```ruby
Valve = Struct.new(:name, :flow_rate, :tunnels)
valves = $stdin.read.scan(/Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/).map do |name, flow_rate, tunnels|
  Valve.new(name, flow_rate.to_i, tunnels.split(', '))
end
$valve_map = valves.map { |v| [v.name, v] }.to_h

# Find shortest path from a given valve
shortest_path = -> from {
  visited = {}
  queue = [[from, []]]
  while !queue.empty?
    current, path = queue.shift
    next if visited[current]
    visited[current] = path
    $valve_map[current].tunnels.each do |tunnel|
      queue << [tunnel, path + [tunnel]]
    end
  end
  visited
}
$shortest_paths = valves.map { |v| [v.name, shortest_path[v.name]] }.to_h
$valves_worth_opening = valves.select { |v| v.flow_rate > 0 }

Actor = Struct.new(:pos, :time, :parent) do
  def path
    "#{parent ? parent.path + ' => ' : ''}#{pos}@#{time - 4}"
  end
  def inspect
    "Actor(#{path})"
  end
  def to_s
    inspect
  end
end
State = Struct.new(:opened, :actors, :open_times) do
  def key
    @key ||= [opened, actors.map(&:pos)]
  end
  def value
    open_times.sum { |v, t| $valve_map[v].flow_rate * (30 - t) }
  end
  def unopened_valves
    @unopened_valves ||= $valves_worth_opening.reject { |v| opened[v.name] }
  end
  def next_states
    out = []
    unopened_valves.each do |v|
      # Select which actor opens that valve
      actors.each_with_index do |actor, i|
        next_time = actor.time + $shortest_paths[actor.pos][v.name].length + 1
        next if next_time >= 30
        next_actors = actors.dup
        next_actors[i] = Actor.new(v.name, next_time, actor)
        out << State.new(
          opened.merge(v.name => true),
          next_actors,
          open_times.merge(v.name => next_time)
        )
      end
    end
    out
  end
  def inspect
    "State([#{opened.keys.sort.join(', ')}], [#{actors.join(', ')}])"
  end
  def to_s
    inspect
  end
end

# For part 1
initial_state = State.new({}, [Actor.new('AA', 0, nil)], {})

# For part 2
initial_state = State.new({}, [Actor.new('AA', 4, nil), Actor.new('AA', 4, nil)], {})

evaluated = 0
best_value = {}
queue = {}
best_value[initial_state.key] = initial_state.value
queue[initial_state.key] = [initial_state]
last_time = 0
start_time = Time.now.to_f
while !queue.empty?
  key = queue.each_key.first
  states = queue.delete(key)
  states.each do |state|
    evaluated += 1
    if Time.now.to_f > last_time + 1
      p [evaluated, queue.size, best_value.size, state, state.value]
      last_time = Time.now.to_f
    end
    state.next_states.each do |s|
      if !best_value[s.key] || s.value > best_value[s.key]
        best_value[s.key] = s.value
        queue[s.key] = [s]
      end
    end
  end
end

p Time.now.to_f - start_time
p best_value.values.max
```

## Day 17

```ruby
rock_shapes = [
  ['####'],
  ['.#.', '###', '.#.'],
  ['..#', '..#', '###'],
  ['#', '#', '#', '#'],
  ['##', '##'],
]
$jet_patterns = gets.strip.chars
$jet = 0

class Board
  def initialize
    @rocks = []
    @occupy = {}
    @height = 0
  end
  def available((i, j))
    return false if i < 0
    return false if j >= 7 || j < 0
    return !@occupy[[i, j]]
  end
  def add(rock_type, dbg = false)
    x = 2
    y = @height + 3
    occ = rock_type.pos(y, x)
    if dbg
      p [@height, y, x, occ]
      visualize(occ)
      sleep 0.1
    end
    loop do
      jet = $jet_patterns[$jet % $jet_patterns.size]
      $jet += 1
      dir = jet == '>' ? 1 : -1
      propose = rock_type.pos(y, x + dir)
      if can_place?(propose)
        occ = propose
        x += dir
        if dbg
          visualize(occ)
          sleep 0.1
        end
      end
      propose = rock_type.pos(y - 1, x)
      if can_place?(propose)
        occ = propose
        y -= 1
        if dbg
          visualize(occ)
          sleep 0.1
        end
      else
        break
      end
    end
    occ.keys.each do |c|
      @occupy[c] = '#'
      @height = c[0] + 1 if c[0] + 1 > @height
    end
    if dbg
      visualize
      p [occ.keys, @height]
    end
  end
  def can_place?(occ)
    occ.keys.all? { |c| available(c) }
  end
  def visualize(add = {})
    occupy = @occupy.merge(add)
    (0..@height + 10).reverse_each do |i|
      puts (0...7).map { |j| occupy[[i, j]] || '.' }.join
    end
    puts
  end
  attr_reader :height
end

class RockType
  attr_reader :occupy
  def initialize(x)
    @height = x.length
    @width = x[0].length
    @occupy = {}
    x.each_with_index do |s, i|
      s.chars.each_with_index do |c, j|
        @occupy[[i, j]] = 1 if c == '#'
      end
    end
  end
  def pos(i0, j0)
    out = {}
    @occupy.each do |(i, j), _|
      out[[i0 + @height - 1 - i, j0 + j]] = '@'
    end
    out
  end
end

rocks = rock_shapes.map { |x| RockType.new(x) }

# Part 1 - Straightforward simulation
board = Board.new
2022.times do |i|
  board.add rocks[i % rocks.size] #, i == 5
  # board.visualize
end
p board.height

# Part 2 - Simulate 50000 iterations, keeping track of height change after placing block,
# brute-force to detect a cycle, and extrapolate to get the result.
board = Board.new
$jet = 0
height_changes = []
last_height = 0
50000.times do |i|
  board.add rocks[i % rocks.size]
  height_changes << board.height - last_height
  last_height = board.height
end

found_cycle_length = ($jet_patterns.length..height_changes.length).find { |x|
  a = height_changes.last(x)
  b = height_changes.last(x * 2).first(x)
  c = height_changes.last(x * 3).first(x)
  a == b && b == c
}

blocks_placed = height_changes.size
height_so_far = height_changes.sum
cycle = height_changes.last(found_cycle_length)
height_increase_per_cycle = cycle.sum
blocks_to_place = 1000000000000 - blocks_placed
cycles_to_place, blocks_to_place = blocks_to_place.divmod(found_cycle_length)
height_so_far += cycles_to_place * height_increase_per_cycle
height_so_far += cycle.take(blocks_to_place).sum
p height_so_far
```

## Day 18

```ruby
voxels = $stdin.readlines.map { |x| x.split(',').map(&:to_i) }
voxels_h = voxels.map { |v| [v, true] }.to_h

# Part 1
group_xy = voxels.group_by { |x, y, z| [x, y] }.map { |k, v| [k, v.map { |x| x[2] } ] }.to_h
group_yz = voxels.group_by { |x, y, z| [y, z] }.map { |k, v| [k, v.map { |x| x[0] } ] }.to_h
group_xz = voxels.group_by { |x, y, z| [x, z] }.map { |k, v| [k, v.map { |x| x[1] } ] }.to_h
surf = -> groups {
  groups.sum { |k, vs|
    vs = vs.sort
    vs.flat_map { |x| [x, x+1] }.group_by {|v|v}.select{|k,v|v.length == 1}.count
  }
}
p surf[group_xy] + surf[group_yz] + surf[group_xz]

# Part 2
x_range = voxels.map { |x, y, z| x }.minmax
y_range = voxels.map { |x, y, z| y }.minmax
z_range = voxels.map { |x, y, z| z }.minmax
queue = [[x_range[0] - 2, y_range[0] - 2, z_range[0] - 2]]
visited = {}
surf = 0
while !queue.empty?
  x, y, z = queue.shift
  point = [x, y, z]
  next if visited[point]
  visited[point] = true
  unless voxels_h[point]
    inject = -> cx, cy, cz {
      queue << [cx, cy, cz] if !visited[[cx, cy, cz]] && cx >= x_range[0] - 2 && cx <= x_range[1] + 2 && cy >= y_range[0] - 2 && cy <= y_range[1] + 2 && cz >= z_range[0] - 2 && cz <= z_range[1] + 2
      if voxels_h[[cx, cy, cz]]
        surf += 1
      end
    }
    inject[x, y, z - 1]
    inject[x, y, z + 1]
    inject[x, y - 1, z]
    inject[x, y + 1, z]
    inject[x - 1, y, z]
    inject[x + 1, y, z]
  end
end
p surf
```

## Day 19

```ruby
class Blueprint < Struct.new(:id, :ore_robot_cost, :clay_robot_cost, :obsidian_robot_cost_ore, :obsidian_robot_cost_clay, :geode_robot_cost_ore, :geode_robot_cost_obsidian)
  def quality_level
    id * geodes_opened(24)
  end
  def geodes_opened(max_time)
    states = [State.new(self, 0,  0, 0, 0, 0,  1, 0, 0, 0)]
    max_time.times do |i|
      states = states.flat_map(&:moves).sort_by { |s| s.fitness }.reverse.take(20000)
      # p [i, states.length, states.map(&:geode).max]
    end
    states.map(&:geode).max
  end
end
class State < Struct.new(:blueprint, :time, :ore, :clay, :obsidian, :geode, :ore_robots, :clay_robots, :obsidian_robots, :geode_robots)
  def fitness
    [geode, heuristic]
  end
  def heuristic
    [geode_robots, obsidian_robots, clay_robots, ore_robots]
  end
  def moves
    out = []

    # Do nothing
    base = tick
    out << base

    # Build ore robot
    if ore >= blueprint.ore_robot_cost
      next_state = base.dup
      next_state.ore -= blueprint.ore_robot_cost
      next_state.ore_robots += 1
      out << next_state
    end

    # Build clay robot
    if ore >= blueprint.clay_robot_cost
      next_state = base.dup
      next_state.ore -= blueprint.clay_robot_cost
      next_state.clay_robots += 1
      out << next_state
    end

    # Build obsidian robot
    if ore >= blueprint.obsidian_robot_cost_ore && clay >= blueprint.obsidian_robot_cost_clay
      next_state = base.dup
      next_state.ore -= blueprint.obsidian_robot_cost_ore
      next_state.clay -= blueprint.obsidian_robot_cost_clay
      next_state.obsidian_robots += 1
      out << next_state
    end

    # Build geode robot
    if ore >= blueprint.geode_robot_cost_ore && obsidian >= blueprint.geode_robot_cost_obsidian
      next_state = base.dup
      next_state.ore -= blueprint.geode_robot_cost_ore
      next_state.obsidian -= blueprint.geode_robot_cost_obsidian
      next_state.geode_robots += 1
      out << next_state
    end
    out
  end
  def tick
    State.new(blueprint, time + 1, ore + ore_robots, clay + clay_robots, obsidian + obsidian_robots, geode + geode_robots, ore_robots, clay_robots, obsidian_robots, geode_robots)
  end
end

input = $stdin.read.scan(/\d+/).each_slice(7).map { |c|
  Blueprint.new(*c.map(&:to_i))
}
p input.map(&:quality_level).sum

a = input[0].geodes_opened(32)
b = input[1].geodes_opened(32)
c = input[2].geodes_opened(32)
p a * b * c
```

## Day 20

<details><summary>Scrappy version</summary>

```ruby
# Part 1
numbers = $stdin.read.lines.map(&:to_i)
index = -> i {
  x = i % numbers.length
  x < 0 ? x + numbers.length : x
}
data = numbers.each_with_index.map { |n, i| [n, i] }
data.dup.each do |n, i|
  swap_times = n.abs
  current_index = data.find_index { |_, j| j == i }
  swap_times.times do |j|
    next_index = index[n > 0 ? current_index + 1 : current_index - 1]
    data[current_index], data[next_index] = data[next_index], data[current_index]
    current_index = next_index
  end
end
index_zero = data.find_index { |i, _| i == 0 }
p data[index[index_zero + 1000]][0] + data[index[index_zero + 2000]][0] + data[index[index_zero + 3000]][0]
```

```ruby
# Part 2
numbers = $stdin.read.lines.map(&:to_i).map { |n| n * 811589153 }
index = -> i {
  x = i % numbers.length
  x < 0 ? x + numbers.length : x
}
data = numbers.each_with_index.map { |n, i| [n, i] }
(data.dup * 10).each do |n, i|
  swap_times = n.abs % (data.length - 1)
  current_index = data.find_index { |_, j| j == i }
  swap_times.times do |j|
    next_index = index[n > 0 ? current_index + 1 : current_index - 1]
    data[current_index], data[next_index] = data[next_index], data[current_index]
    current_index = next_index
  end
end
p data
index_zero = data.find_index { |i, _| i == 0 }
p data[index[index_zero + 1000]][0] + data[index[index_zero + 2000]][0] + data[index[index_zero + 3000]][0]
```

</details>

After I learn that Ruby can do circular arrays:

```ruby
$decryption_key = 1;         $times_to_repeat = 1    # Part 1
$decryption_key = 811589153; $times_to_repeat = 10   # Part 2
data = $stdin.read.lines.map(&:to_i).each_with_index.map { |n, i| [n * $decryption_key, i] }
(data.dup * $times_to_repeat).each do |n, i|
  data.rotate! data.find_index { |_, j| j == i }
  value, _ = data.shift
  data.rotate! value
  data.unshift [value, i]
end
data.rotate! data.find_index { |n, i| n == 0 }
p data[1000 % data.length][0] + data[2000 % data.length][0] + data[3000 % data.length][0]
```

## Day 21

```ruby
# Part 1
lines = $stdin.readlines
all = []
lines.each do |l|
  if l =~ /(\w+): (.+)/
    name = $1
    code = $2
    all << "x[:#{name}] = -> { c[:#{name}] ||= #{code.gsub(/([a-z]+)/) { "x[:#{$1}][]" }} }"
  end
end
x = {}
c = {}
puts all
eval all.join("\n")
p x[:root][]
```

```ruby
# Part 2
# Parse inputs
lines = $stdin.readlines
codes = {}
lines.each do |l|
  if l =~ /(\w+): (.+)/
    name = $1
    code = $2
    code = code.sub('+') { '==' } if name == 'root'
    code = code.sub('humn') { "$YOU" }
    codes[name] = code
  end
end

# Inline all monkeys
code = codes['root']
last_code = code
loop do
  code = code.gsub(/([a-z]+)/) {
    subcode = codes[$1]
    if subcode =~ /(\d+)/
      $1
    else
      "(#{subcode})"
    end
  }
  p code
  break if last_code == code
  last_code = code
end

# Binary search to find the number
code = code.gsub('==', '-')
$YOU = 3220000000000
found = (0..9999999999999).bsearch do |i|
  $YOU = i
  result = eval code
  p [i, result]
  result <= 0
end
p found
$YOU = found
p eval code
```

## Day 22

```ruby
# Part 1
map = {}
lines = $stdin.readlines
place = nil
lines.each_with_index do |l, y|
  l.chomp.chars.each_with_index do |c, x|
    map[[x, y]] = c if c != ' '
    place = [x, y] unless place
  end
  break if l.strip.empty?
end
# p lines.last
x_min, x_max = map.keys.map(&:first).minmax
y_min, y_max = map.keys.map(&:last).minmax

facing = [1, 0]
rotate_right = -> dx, dy { [-dy, dx] }
rotate_left = -> dx, dy { [dy, -dx] }

draw = -> {
  (y_min..y_max).each do |y|
    (x_min..x_max).each do |x|
      c = map[[x, y]]
      if c.nil?
        print ' '
      elsif [x, y] == place
        print case facing
              when [1, 0] then '>'
              when [-1, 0] then '<'
              when [0, 1] then 'v'
              when [0, -1] then '^'
              end
      else
        print c
      end
    end
    puts
  end
  puts '======================='
}

p path = lines.last.scan(/\d+|R|L/)
path.each do |v|
  if v == 'R'
    facing = rotate_right[*facing]
  elsif v == 'L'
    facing = rotate_left[*facing]
  else
    v.to_i.times do
      next_place = [place.first + facing.first, place.last + facing.last]
      char = map[next_place]
      if char.nil?
        ys_on_x = map.keys.select { |x, y| x == next_place.first }.map(&:last)
        xs_on_y = map.keys.select { |x, y| y == next_place.last }.map(&:first)
        if facing == [1, 0]
          next_place = [xs_on_y.min, next_place.last]
        elsif facing == [-1, 0]
          next_place = [xs_on_y.max, next_place.last]
        elsif facing == [0, 1]
          next_place = [next_place.first, ys_on_x.min]
        elsif facing == [0, -1]
          next_place = [next_place.first, ys_on_x.max]
        end
        char = map[next_place]
      end
      if char == '#'
        break
      end
      place = next_place
      # draw[]
      # sleep 0.1
    end
  end
  # draw[]
  # sleep 0.1
end
draw[]
p [place, facing]
facing_score = case facing
                when [1, 0] then 0
                when [-1, 0] then 2
                when [0, 1] then 1
                when [0, -1] then 3
                end
row = place[1] + 1
col = place[0] + 1
p row * 1000 + col * 4 + facing_score
```

```ruby
# Part 2
$cube_data = {
  A: {
    origin: [1, 0],
    up: [:F, 1],
    down: [:C, 0],
    left: [:E, 2],
    right: [:B, 0],
  },
  B: {
    origin: [2, 0],
    up: [:F, 0],
    down: [:C, 1],
    left: [:A, 0],
    right: [:D, 2],
  },
  C: {
    origin: [1, 1],
    up: [:A, 0],
    down: [:D, 0],
    left: [:E, 3],
    right: [:B, 3],
  },
  D: {
    origin: [1, 2],
    up: [:C, 0],
    down: [:F, 1],
    left: [:E, 0],
    right: [:B, 2],
  },
  E: {
    origin: [0, 2],
    up: [:C, 1],
    down: [:F, 0],
    left: [:A, 2],
    right: [:D, 0],
  },
  F: {
    origin: [0, 3],
    up: [:E, 0],
    down: [:B, 0],
    left: [:A, 3],
    right: [:D, 3],
  }
}

class Cube
  def initialize(size)
    @size = size
  end
  def face_coord(point)
    $cube_data.each do |k, v|
      origin = v[:origin]
      if point[0] >= origin[0] * @size && point[0] < (origin[0] + 1) * @size &&
          point[1] >= origin[1] * @size && point[1] < (origin[1] + 1) * @size
        return [k, point[0] - origin[0] * @size, point[1] - origin[1] * @size]
      end
    end
    raise "no face for #{point}"
  end
  def resolve(from, to)
    from_face, from_x, from_y = from
    to_x, to_y = to
    instructions = nil
    go = ->(dir, dx, dy) {
      to_face, rotation = $cube_data[from_face][dir]
      tx, ty = to_x + dx, to_y + dy
      rotate_right = -> {
        tx, ty = @size - ty - 1, tx
      }
      rotation.times { rotate_right[] }
      [to_face, tx, ty, rotation]
    }
    if to_y < 0
      go[:up, 0, @size]
    elsif to_y >= @size
      go[:down, 0, -@size]
    elsif to_x < 0
      go[:left, @size, 0]
    elsif to_x >= @size
      go[:right, -@size, 0]
    else
      return [from_face, to_x, to_y, 0]
    end
  end
  def xy_coord(face_coord)
    face, x, y = face_coord
    origin = $cube_data[face][:origin]
    [origin[0] * @size + x, origin[1] * @size + y]
  end
end

$cube = Cube.new(50)

map = {}
lines = $stdin.readlines
place = nil
lines.each_with_index do |l, y|
  l.chomp.chars.each_with_index do |c, x|
    if c != ' '
      map[[x, y]] = c
      place = [x, y] unless place
    end
  end
  break if l.strip.empty?
end
# p lines.last
x_min, x_max = map.keys.map(&:first).minmax
y_min, y_max = map.keys.map(&:last).minmax

facing = [1, 0]
rotate_right = -> dx, dy { [-dy, dx] }
rotate_left = -> dx, dy { [dy, -dx] }
p board_size = y_max - y_min + 1

wrap = -> place, next_place, facing {
  face_coord = $cube.face_coord(place)
  p ['WRAP', place, next_place, facing, face_coord]

  dx, dy = next_place[0] - place[0], next_place[1] - place[1]
  next_face, nx, ny, rotations = $cube.resolve(face_coord, [face_coord[1] + dx, face_coord[2] + dy])
  next_place = $cube.xy_coord([next_face, nx, ny])
  rotations.times { facing = rotate_right[*facing] }
  [next_place, facing]
}

draw = -> {
  (y_min..y_max).each do |y|
    (x_min..x_max).each do |x|
      c = map[[x, y]]
      if c.nil?
        print ' '
      elsif [x, y] == place
        print case facing
              when [1, 0] then '>'
              when [-1, 0] then '<'
              when [0, 1] then 'v'
              when [0, -1] then '^'
              end
      else
        print c
      end
    end
    puts
  end
  puts '======================='
}

p path = lines.last.scan(/\d+|R|L/)
path.each do |v|
  if v == 'R'
    facing = rotate_right[*facing]
  elsif v == 'L'
    facing = rotate_left[*facing]
  else
    v.to_i.times do
      next_place = [place.first + facing.first, place.last + facing.last]
      next_facing = facing
      char = map[next_place]
      if char.nil?
        next_place, next_facing = wrap[place, next_place, facing]
        char = map[next_place]
      end
      if char == '#'
        break
      end
      place = next_place
      facing = next_facing
      # draw[]
      # sleep 0.1
    end
  end
  # draw[]
  # sleep 0.1
end
draw[]
p [place, facing]
facing_score = case facing
                when [1, 0] then 0
                when [-1, 0] then 2
                when [0, 1] then 1
                when [0, -1] then 3
                end
row = place[1] + 1
col = place[0] + 1
p row * 1000 + col * 4 + facing_score
```