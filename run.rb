$blocks = []
def solution(&block)
    $blocks << block
end

load 'work.rb'

$blocks.last&.call