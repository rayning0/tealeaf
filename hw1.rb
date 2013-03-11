#1. Use the "each" method of Array to iterate over [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], and print out each value.

x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
x.each {|i| puts i}
puts

#2. Same as above, but only print out values greater than 5.

=begin
x.each do |i|
	if i > 5
		puts i
	end
end

x.each do |i|
  puts i if i > 5
end
=end

puts x.select {|i| i > 5}
puts

#3. Now, using the same array from #2, use the "select" method to extract all odd numbers into a new array.

# y = x.select {|i| i % 2 == 1}

puts x.select {|i| i.odd?}
puts

#4. Append "11" to the end of the array. Prepend "0" to the beginning.

x.push(11)
x.unshift(0)
puts x
puts

#5. Get rid of "11". And append a "3".

x.pop
x.push(3)
puts x
puts

#6. Get rid of duplicates without specifically removing any one value. 

puts x.uniq
puts

#7. What's the major difference between an Array and a Hash?

=begin
Arrays are indexed by integers, starting with 0 and increasing in numberical order. (-1 means the last item, -2 is the second to last item, etc.) Hashes are indexed by arbitrary keys of any object type. Arrays are collections of any object. Hashes are key/value pairs of any object. The keys are in the order the objects were inserted. We may specify a default value for our hash if we seek a key that doesn't exist. We can't do this for arrays.

Also, arrays can have repeated elements, but hashes may not have repeated keys. Arrays preserve order. Hashes do not!
=end

#8. Create a Hash using both Ruby 1.8 and 1.9 syntax.

puts hash1 = {:foo => "bar", :foo2 => "bar2", :foo3 => 3, "foo4" => :foo4}  # Ruby 1.8 syntax
puts hash2 = {foo: "bar", foo2: "bar2", foo3: 3, "foo4" => :foo4}  # Ruby 1.9 syntax. 1st 3 keys are symbols.
puts

h = {a:1, b:2, c:3, d:4}  # all keys are symbols----h = {:a=>1, :b=>2, :c=>3, :d=>4} in Ruby 1.8

#9. Get the value of key "b".

puts h[:b]  # don't do h["b"] or h[b], since key is a symbol
puts

#10. Add to this hash the key:value pair {e:5}

h[:e] = 5
puts h
puts

#13. Remove all key:value pairs whose value is less than 3.5

h.delete_if {|key, value| value < 3.5}
puts h
puts

#14. Can hash values be arrays? Can you have an array of hashes? (give examples)

# Yes and yes!

h[:f] = [1, 2]
h[:g] = [3, 4, 5]
puts h
puts

hash3 = {key1: "value1", key2: "value2"}
j = [hash3, hash2, h]
puts j[0]
puts j[1]
puts j[2]
puts

#15. Look at several Rails/Ruby online API sources and say which one your like best and why.

=begin
My favorite Ruby API source is http://www.ruby-doc.org/
My favorite Rails API source is http://api.rubyonrails.org/, http://railsapi.com/

I like both because they are easy to search for classes and methods.
=end