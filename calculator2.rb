begin
	puts "Calculator. What's number 1?"
	n1 = gets.chomp
	puts "Number 1 was #{n1} and it's class #{n1.class}."
	puts "What's number 2?"
	n2 = gets.chomp
	puts "Number 2 was #{n2} and it's class #{n2.class}."

	puts "What operation do you want? 1) Add 2) Subtract 3) Divide 4) Multiply"
	operator = gets.chomp
	result = nil

	case operator
		when '1'
			result = n1.to_f + n2.to_f
			operator = "+"
		when '2'
			result = n1.to_f - n2.to_f
			operator = "-"
		when '3'
			result = n1.to_f / n2.to_f  # convert to float so decimal part of answer is not cut off
			operator = "/"
		when '4'
			result = n1.to_f * n2.to_f
			operator = "x"
		else
			puts "Enter 1, 2, 3, or 4."
	end
	puts "#{n1} #{operator} #{n2} = #{result.round(4)}"  # rounds answer to 4 decimal places
	puts "Do it again? (y/n)"
	again = gets.chomp.downcase
end until (again == 'n' || again == 'no')
