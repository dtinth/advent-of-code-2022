require 'minitest'
include Minitest::Assertions
class << self
  attr_accessor :assertions
end
self.assertions = 0

$blocks = []
def solution(&block)
    $blocks << block
end

load 'work.rb'

$blocks.last&.call