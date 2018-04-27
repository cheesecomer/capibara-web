begin
  Participant.all.destroy_all
rescue => exception; end