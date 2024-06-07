# frozen_string_literal: true

# Facilitates the connection between the clients and the game
class WarSocketRunner
  attr_accessor :game, :clients, :ready_state

  def initialize(game, clients)
    @game = game
    @clients = clients
    @ready_state = []
    @clients_sent_messages = []
  end

  def run
    game.start
    run_loop until game.winner
    message_players("#{game.winner.name} wins the game!")
    clients.each(&:close)
  end

  def players_ready?
    (clients - ready_state).each do |client|
      input = capture_input(client)
      ready_state << client if input == 'play'
    end
    ready_state.length == clients.length
  end

  def message_players(message)
    clients.each { |client| client.puts(message) }
  end

  def run_loop
    if players_ready?
      game.play_round
      message_players(game.round_state)
      game.round_state = ''
      ready_state.clear
      @clients_sent_messages.clear
    elsif ready_state.empty? && @clients_sent_messages.empty?
      message_players('Type "play" to play a card:')
      @clients_sent_messages = clients.dup
    end
  end

  def capture_input(client)
    client.read_nonblock(1000).chomp
  rescue IO::WaitReadable
    ''
  end
end
