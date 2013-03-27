class Card
  attr_accessor :value, :suit
  def initialize(v, s)
    @value = v
    @suit = s
  end

  def pretty_output
    "#{value} of #{suit}"
  end

  def to_s
    pretty_output
  end
end

class Deck
  attr_accessor :cards
  def initialize
    @cards = []
    @values = %w[Ace 2 3 4 5 6 7 8 9 10 Jack Queen King]
    @suits = %w[Hearts Diamonds Clubs Spades]

    @values.each do |value|
      @suits.each do |suit|
        @cards << Card.new(value, suit)
      end
    end

    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.shift
  end

  def size
    cards.size
  end
end

module Hand
  def show_hand
    puts "---- #{name}'s Cards ----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end

  def total
    # make array of only face values
    face_values = cards.map{ |card| card.value} 

    total = 0   # total value of hand
    aces = 0    # number of aces in hand
    face_values.each do |val|
      if val == "Ace"
        # for all aces, increase total by 11 (will correct later)
        total += 11
        aces += 1
      else
        # if card is Jack, Queen, or King, increase total by 10
        # else increase total by face value 
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    # For each ace, subtract 10 till total <= 21

    aces.times do
      break if total <= Game::BLACKJACK_VALUE
      total -= 10
    end

    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def busted?
    total > Game::BLACKJACK_VALUE
  end

  def blackjack?
    total == Game::BLACKJACK_VALUE
  end
end

class Player
  include Hand

  attr_accessor :name, :cards
  
  def initialize(n)
    @name = n 
    @cards = []
  end

  def show_hands
    show_hand
  end
end

class Dealer
  include Hand
  
  attr_accessor :name, :cards
  
  def initialize
    @name = "Dealer"
    @cards = []  
  end

  def show_hands
    puts "---- Dealer's Hand ----"
    puts "=> First card is hidden"
    puts "=> Second card: #{cards[1]}"
  end
end

class Game
  attr_accessor :deck, :player, :dealer, :wins, :games

  BLACKJACK_VALUE = 21 
  DEALER_HIT_MIN = 17

  def initialize
    @deck = Deck.new 
    @player = Player.new("")
    @dealer = Dealer.new
    @wins = 0   # of wins
    @games = 0  # of total games
  end

  def player_name
    while player.name == ""
      puts "What's your name?"
      player.name = gets.chomp
    end
  end

  def out_of_cards?
    if deck.size == 0
      puts "We're out of cards. Start a new deck."
      exit
    end
  end

  def deal_cards   # start of new game
    @games += 1    # why do I need @ for games and wins? Undefined method ("+") error
    if deck.size >= 4
      player.add_card(deck.deal_one)
      dealer.add_card(deck.deal_one)
      player.add_card(deck.deal_one)
      dealer.add_card(deck.deal_one)
    else
      puts "We're out of cards. Start a new deck."
      exit
    end
  end

  def show_all_hands
    puts "#{deck.size} cards left"    
    player.show_hands
    dealer.show_hands
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.blackjack?
      if player_or_dealer.is_a?(Dealer)
        puts "Dealer has blackjack. Dealer wins."
      else
        puts "Yay! BLACKJACK! #{player.name} wins!\a"
        @wins += 1
      end
      play_again?
    elsif player_or_dealer.busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Dealer busted. #{player.name} wins!\a"
        @wins += 1
      else
        puts "You busted. Dealer wins."
      end
      play_again?
    end
  end

  def player_turn
    puts "#{player.name}'s turn."
    blackjack_or_bust?(player)

    while !player.busted?
      out_of_cards?
      puts "1) Hit or 2) Stay?"
      answer = gets.chomp
      if !['1', '2'].include?(answer)
        puts "Error: enter 1 or 2"
        next
      end

      break if answer == '2'

      # hit
      new_card = deck.deal_one
      puts "#{deck.size} cards left"
      puts "#{player.name}'s new card: #{new_card}"
      player.add_card(new_card)
      puts "#{player.name}'s new total: #{player.total}"

      blackjack_or_bust?(player)
    end
    puts "#{player.name} stays at #{player.total}"
  end

  def dealer_turn
    puts "Dealer's turn"

    blackjack_or_bust?(dealer)
    while dealer.total < DEALER_HIT_MIN
      out_of_cards?
      new_card = deck.deal_one
      puts "Dealer's new card: #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer's new total: #{dealer.total}"
      blackjack_or_bust?(dealer)
    end
    puts "Dealer stays at #{dealer.total}"
  end

  def who_won?    # no blackjack or bust
    if player.total > dealer.total
      puts "Congratulations, #{player.name} wins!\a"
      @wins += 1
    elsif player.total < dealer.total
      puts "Sorry. Dealer wins."
    else
      puts "It's a tie. Push."
      @wins += 1
    end
    play_again?
  end

  def play_again?
    answer = ""
    puts "\nYou've won/tied #{wins} out of #{games} game#{ games == 1 ? '' : 's' }."

  # could not get this loop to work with 
  # if !["Y", "N"].include?(answer) and next. Gave me "next" error

    while !["Y", "N"].include?(answer)
      puts "Play again? Yes/No"
      answer = gets.chomp.upcase.slice(0) # answer = 1st character, uppercase
      if answer == "N"
        exit
      elsif answer == "Y"
        puts "New game...\n"
        player.cards = []
        dealer.cards = []
        start   # don't open new deck. Keep same one. 
      end
    end 
  end

  def start
    player_name if games == 0  # only ask player's name at start of new deck
    deal_cards
    show_all_hands
    player_turn
    dealer_turn
    who_won?
  end
end

game = Game.new.start