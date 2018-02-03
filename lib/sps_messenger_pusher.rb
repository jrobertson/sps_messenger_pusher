#!/usr/bin/env ruby


# file: sps_messenger_pusher.rb

# description: The intent is to publish SPS messages at a regular interval for someone to be kept up to date with information they are interested in.
#
# Messages could include: 
#
#   * weather info
#   * reminders (e.g. upcoming events or appointsments, to-do list)
#   * unread important email
#   * local news headlines
#   * price of Bitcoin
#   * latest RSS headlines etc.

require 'sps-sub'
require 'rss_to_dynarex'


class SPSMessengerPusher < SPSSub

  def initialize(port: '59210', host: nil, feed: nil )

    super(port: port, host: host)
    @feed = feed
    @messages = fetch_feed()

  end

  def start(interval: 8)

    @interval = interval
    Thread.new { subscribe() }

    play @messages

  end

  private

  def fetch_feed()
    
    rtd = RSStoDynarex.new @feed
    rtd.to_dynarex.all.map(&:title)

  end

  def play(messages=@messages)

    @status = :play
    old_message = ''
    
    messages.cycle.each do |message|
 
      notice('messenger: ' + message) unless message == old_message
      sleep @interval
      break if @status == :stop
      old_message = message

    end

  end

  def subscribe(topic: 'messenger/status')
    messages = @messages
    super(topic: topic) do |msg, topic|

      case msg.to_sym

      when :update
        @status = :stop
        messages = fetch_feed()
        play messages
      
      when :stop

        @status = :stop

      when :play

        play

      end

    end

  end

end
