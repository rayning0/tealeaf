game = 0   # number of games played
won = 0   # number of games you've won
puts "Welcome to Blackjack! What's your name?"
name = gets.chomp

def new_deck
  d = Array.new 

  (1..4).each do |suit|
    (1..13).each do |value|
      case value
      when 1
        v = "Ace"
      when 2..10
        v = value.to_s
      when 11
        v = "Jack"
      when 12
        v = "Queen"
      when 13
        v = "King"
      end

      case suit
      when 1
        d.push([v, "Clubs"])
      when 2
        d.push([v, "Diamonds"])
      when 3
        d.push([v, "Hearts"])
      when 4
        d.push([v, "Spades"])
      end
    end
  end

  return d.shuffle  # shuffle the deck!
end


def total(card)
  t = 0  # total
  a = 0  # number of aces

  (0..card.size - 1).each do |i|
    val = card[i][0]
    case val
    when "Ace"
      a += 1
      t += 1
    when "Jack"
      t += 10
    when "Queen"
      t += 10
    when "King"
      t += 10
    else
      t += val.to_i
    end
  end

  return t, a
end

deck = new_deck     # create and shuffle new deck

begin
  game += 1
  you = Array.new
  dealer = Array.new
# deck = new_deck   --- use this instead to get fresh deck for each game

# Deal cards

  if deck.size >= 4
    you[0] = deck.shift
    dealer[0] = deck.shift
    you[1] = deck.shift
    dealer[1] = deck.shift
  else
    puts "We are out of cards. Start a new deck."
    end_game = true
    break
  end  

  puts "\nDealing...There are now #{deck.size} cards in the deck.\n"

  # puts "Dealer's 1st card: #{dealer[0][0]} of #{dealer[0][1]}"
  puts "Dealer's 2nd card: #{dealer[1][0]} of #{dealer[1][1]}"

  puts "-----Your cards-----"
  puts "Your 1st card: #{you[0][0]} of #{you[0][1]}"
  puts "Your 2nd card: #{you[1][0]} of #{you[1][1]}"

  tot_you, aces_you = total(you)  # calculate total of hand
  print "Your total: #{tot_you} "

# If have at least 1 ace and we can treat it as 11 

  if (aces_you > 0) and (tot_you + 10 < 22)  
      puts "or #{tot_you + 10}"
  end

  tot_dealer, aces_dealer = total(dealer)
  # print "\nDealer total: #{tot_dealer} "
  # if (aces_dealer > 0) and (tot_dealer + 10 < 22)  
  #    puts "or #{tot_dealer + 10}"
  # end

# Hit or Stay
 
  begin
    end_game = false

    begin
      puts "\nWhat will you do, #{name}? 1) Hit 2) Stay"
      hit = gets.chomp.to_i
    end until (hit == 1 or hit == 2)  # ensure you enter only 1 or 2

    if hit == 1
      you << deck.shift
      if deck.size == 0
        puts "We are out of cards. Start a new deck."
        end_game = true
        break
      end
      
      puts "There are now #{deck.size} cards in the deck."
      k = you.size - 1
      puts "You drew card #{k + 1}: #{you[k][0]} of #{you[k][1]}"

      tot_you, aces_you = total(you)
      print "Your total: #{tot_you} "
      if (aces_you > 0) and (tot_you + 10 < 22)  
          puts "or #{tot_you + 10}"
      end      
    end
    if tot_you === 21 or (aces_you > 0 and tot_you + 10 == 21) 
      puts "\n**** BLACKJACK! You WIN! **** \a"
      won += 1
      end_game = true
      break
    end
    if tot_you > 21
      puts "\nYou BUSTED!!! Dealer WINS!!!"
      end_game = true
      break
    end
  end until hit == 2

  # if counting an ace as 11 won't go over 21
  if (aces_you > 0) and (tot_you + 10 < 22)
    tot_you = tot_you + 10
  end

# Dealer's turn

  if end_game == false
    if tot_dealer === 21 or (aces_dealer > 0 and tot_dealer + 10 == 21) 
      puts "\n**** BLACKJACK! Dealer WINS! ****"
      end_game = true
    end

    if (tot_dealer > 16 and tot_dealer > tot_you) 
      puts "\n Dealer wins! No blackjack, but he has more than you."
      end_game = true
    end

    if (aces_dealer > 1 and tot_dealer + 10 > tot_you and tot_dealer + 10 < 22)
      puts "\n Dealer wins! No blackjack, but he has more than you."
      end_game = true
    end

    puts "\nDealer's turn"
    puts "-----Dealer's cards-----"
    (0..dealer.size - 1).each do |i|
      puts "Dealer's card #{i + 1}: #{dealer[i][0]} of #{dealer[i][1]}"
    end

    while tot_dealer < 17   # dealer must hit
      dealer << deck.shift
      if deck.size == 0
        puts "We are out of cards. Start a new deck."
        end_game = true
        break
      end

      j = dealer.size - 1
      puts "\nDealer's card #{j + 1}: #{dealer[j][0]} of #{dealer[j][1]}"

      tot_dealer, aces_dealer = total(dealer)
      print "Dealer total: #{tot_dealer} "
      if (aces_dealer > 0) and (tot_dealer + 10 < 22)  
        puts "or #{tot_dealer + 10}"
      end 

      if tot_dealer === 21 or (aces_dealer > 0 and tot_dealer + 10 == 21) 
        puts "\n**** BLACKJACK! Dealer WINS! ****"
        end_game = true
      end
      if tot_dealer > 21
        puts "\nDealer BUSTED!!! You WIN!!! \a"
        won += 1
        end_game = true
      end
    end

    if end_game == false
      tot_dealer, aces_dealer = total(dealer)
      print "Dealer total: #{tot_dealer} "
      if (aces_dealer > 0) and (tot_dealer + 10 < 22)  
        puts "or #{tot_dealer + 10}"
      end 
    end

    # if counting an ace as 11 won't go over 21

    if (aces_dealer > 0) and (tot_dealer + 10 < 22)
      tot_dealer = tot_dealer + 10
    end

    # Final comparison. Both you and dealer  
    if end_game == false
      case tot_you <=> tot_dealer
      when 0
        puts "\nPush. It's a tie."
        won += 1
      when 1
        puts "\nYou win!\a No blackjack, but you have more than dealer."
        won += 1
      when -1
        puts "\nDealer wins! No blackjack, but he has more than you."
      end
    end
      
  end

  puts "You've won/tied #{won} out of #{game} games."
  puts "Play again, #{name}? (y/n)"
  again = gets.chomp.downcase
  
end until (again == 'n' or again == 'no')