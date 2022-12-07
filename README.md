# Advent of Code 2022

## My workflow

I have in the repo `work.rb` and `input.txt`. I open the project in VS Code and hit Cmd+Shift+B. This will trigger the [build task](./.vscode/tasks.json) that runs a file watcher (`npm install --global onchange`) which will run the code whenever I save.

## Personal stats

```
      -------Part 1--------   -------Part 2--------
Day       Time  Rank  Score       Time  Rank  Score
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
```