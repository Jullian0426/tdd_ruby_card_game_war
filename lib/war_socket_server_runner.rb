# frozen_string_literal: true

require_relative 'war_socket_server'

server = WarSocketServer.new
server.start
loop do
  server.accept_new_client
  server.new_player
  game = server.create_game_if_possible
  server.run_game(game) if game
  begin
  rescue
    server.stop
  end
end
