game = 0   # number of games played
won = 0   # number of games you've won
puts "Welcome to Blackjack! What's your name?"
name = gets.chomp

def new_deck
  d = Array.new 
  value = ["Ace", 2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King"].shuffle
  suit = ["Clubs", "Diamonds", "Hearts", "Spades"].shuffle

  d = value.product(suit)  
  # product() distributively multiplies value and suit arrays together! 
  # it creates [["Ace", "Clubs"], ["Ace", "Diamonds"], ["Ace", "Hearts"], etc...]

=begin   -----no need to do this!
  suit.each do |s|
    value.each do |v|
      d << [v, s]
    end
  end
=end

  return d.shuffle  # shuffle the deck!
end

def total(person, hand)  # calculate & print total of hand
  t = 0  # total value, assuming Ace has value of 1
  t2 = 0 # total value, assuming Ace has value of 11
  a = 0  # number of aces

  (0..hand.size - 1).each do |i|
    val = hand[i][0]
    case val
    when "Ace"
      a += 1
      t += 1
    when "Jack", "Queen", "King"
      t += 10
    else
      t += val
    end
  end

  print "#{person}'s total: #{t}  "

# if have at least 1 Ace and it won't bust to use Ace = 11, set t2 > 0
  if (a > 0) and (t + 10 < 22)  
    t2 = t + 10
    puts "or #{t2}"
  end

  return t, t2, a
end

def print_card(person, hand, num)
  puts "#{person} card #{num + 1}: #{hand[num][0]} of #{hand[num][1]}"
end

def deal_cards(person, decks)
    yours = []
    deals = []
    yours[0] = decks.shift
    deals[0] = decks.shift
    yours[1] = decks.shift
    deals[1] = decks.shift

    puts "\nDealing...There are now #{decks.size} cards in the deck.\n"
 #  print_card("Dealer's", deals, 0)
    print_card("Dealer's", deals, 1)
    puts "-----Your cards-----"
    print_card(person + "'s", yours, 0)
    print_card(person + "'s", yours, 1)
 
    return yours, deals
end

def check(person, tot, tot2, w)   # see if anyone got blackjack or busted
    eg = false

    if tot == 21 or tot2 == 21
      puts "\n**** BLACKJACK! #{person} WINS! ****"
      eg = true     # end_game = true
      if person != "Dealer"  # you won
        print "\a"  # make sound if you win
        w += 1      # increase number of games you won
      end
    end

    if tot > 21
      puts "\n#{person} BUSTED!!!"
      if person == "Dealer"
        puts "You win!\a"
        w += 1
      else
        puts "Dealer won!"
      end
      eg = true
    end  

    return w, eg 
end

deck = new_deck     # create and shuffle new deck

begin               # start main game loop
  game += 1
  you = Array.new
  dealer = Array.new
# deck = new_deck   --- use this instead for fresh deck for each game

# Deal cards
  if deck.size >= 4
    you, dealer = deal_cards(name, deck)
  else
    puts "We are out of cards. Start a new deck."
    end_game = true
    break
  end 

# Calculate and print total of hand
  tot_you, tot2_you, aces_you = total(name, you)  

# Your turn
  begin
    end_game = false

    begin
      puts "\nWhat will you do, #{name}? 1) Hit 2) Stay"
      hit = gets.chomp.to_i
    end until (hit == 1 or hit == 2)  # ensure you enter only 1 or 2

    if hit == 1
      you << deck.shift   # get new card
      if deck.size == 0
        puts "We are out of cards. Start a new deck."
        end_game = true
        break
      end
      
      puts "There are now #{deck.size} cards in the deck."
      print_card("You drew", you, you.size - 1)
      tot_you, tot2_you, aces_you = total(name, you) 
    end

    won, end_game = check(name, tot_you, tot2_you, won)
  end until hit == 2 or end_game == true

  # if counting an ace as 11 won't bust you
  if (tot2_you > 0)     # tot2 > 0 only if it won't bust hand
    tot_you = tot2_you  # set your total to Ace = 11 total
  end

# Dealer's turn

  if end_game == false
    tot_dealer, tot2_dealer, aces_dealer = total("Dealer", dealer)  
    won, end_game = check("Dealer", tot_dealer, tot2_dealer, won)

    puts "\nDealer's turn"
    puts "-----Dealer's cards-----"
    (0..dealer.size - 1).each do |i|
      print_card("Dealer's", dealer, i)
    end

    if (tot_dealer > 16 and tot_dealer > tot_you)  # dealer can't hit any more
      puts "\nDealer wins! No blackjack, but he has more than you."
      end_game = true
    end

    if tot2_dealer > tot_you
      puts "\nDealer wins! No blackjack, but he has more than you."
      end_game = true
    end

    while tot_dealer < 17   # dealer must hit
      dealer << deck.shift  # dealer picks a card
      if deck.size == 0
        puts "We are out of cards. Start a new deck."
        end_game = true
        break
      end

      print_card("\nDealer's", dealer, dealer.size - 1)

      tot_dealer, tot2_dealer, aces_dealer = total("Dealer", dealer)

      won, end_game = check("Dealer", tot_dealer, tot2_dealer, won)
    end

    if end_game == false
      tot_dealer, tot2_dealer, aces_dealer = total("Dealer", dealer)

      # if counting an ace as 11 won't go over 21

      if (tot2_dealer > 0)
        tot_dealer = tot2_dealer
      end

    # Final comparison. Both you and dealer  
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