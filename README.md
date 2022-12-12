# Advent of Code 2022

## My workflow

I have in the repo `work.rb` and `input.txt`. I open the project in VS Code and hit Cmd+Shift+B. This will trigger the [build task](./.vscode/tasks.json) that runs a file watcher (`npm install --global onchange`) which will run the code whenever I save.

## Personal stats

```
      -------Part 1--------   -------Part 2--------
Day       Time  Rank  Score       Time  Rank  Score
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