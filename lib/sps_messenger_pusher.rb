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

    play_messages

  end

  private

  def fetch_feed()
    
    rtd = RSStoDynarex.new @feed
    rtd.to_dynarex.all.map(&:title)

  end

  def play_messages()

    @status = :play
    old_message = ''
    
    @messages.cycle.each do |message|
 
      notice('messenger: ' + message) unless message == old_message
      sleep @interval
      break if @status == :stop or @status == :update
      old_message = message

    end
    
    play_messages if @status == :update

  end

  def subscribe(topic: 'messenger/status')

    super(topic: topic) do |msg, topic|

      case msg.to_sym

      when :update
        @status = :update
        @messages = fetch_feed()
        #play messages
      
      when :stop

        @status = :stop

      when :play

        play_messages

      end

    end

  end

end
