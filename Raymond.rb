class Raymond
  attr_accessor :emotion1, :emotion2, :c
  def initialize(aaahhh, baaahhh)
    @emotion1 = aaahhh
    @emotion2 = baaahhh
    @c = 0
  end
  
  def works_hard
    puts "\n" * 3

    puts "Today is object-oriented day. I'm spending all day watching Tealeaf's object-oriented videos and redesigning my blackjack program into an object-oriented way."

    puts "\nI'm #{emotion1} but #{emotion2}! This is the first time I truly understand how to write a class and think in an object-oriented way."

    puts "\nAlso, Sublime Text (http://www.sublimetext.com/) is the most kickass code editor ever! For example, it lets you set MULTIPLE CURSORS and write the same words on several lines simultaneously! It blows me away."
  end

  def sleeps
    puts "\nHere's Raymond sleeping:"
    puts "Z" * 50
    puts "\nHe really needs this, so he can feel #{emotion1} and #{emotion2}."
    puts "\n" * 4
    emotion1 = "cccccc"
    puts "#{emotion1}"
    @c = c + 1    
  # why is @ necessary? why does c = c + 1 give "undefined method `+' for nil:NilClass (NoMethodError)"
    puts "#{c}"
  end
end

r = Raymond.new("tired", "fascinated")
r.works_hard

r.emotion1 = "well rested"
r.emotion2 = "sane"
r.sleeps
