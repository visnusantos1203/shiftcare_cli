#!/usr/bin/env ruby
require 'json'
require "thor"

class ShiftcareCli < Thor
  def initialize(*args)
    super
    @data = JSON.parse(File.read('clients.json'))
  end

  desc "duplicate_emails", "Find clients with duplicate emails"

  def duplicate_emails
    puts 'Finding clients with duplicate emails...'

    email_groups = @data.group_by { |client| client['email'] }
    duplicates = email_groups.select { |email, clients| clients.size > 1 }

    if duplicates.empty?
      puts "No duplicate emails found."
    else
      puts "Duplicate emails found"
      duplicates.each do |email, clients|
        puts "Email: #{email}, Clients: #{JSON.pretty_generate(clients)}"
      end
    end
  end

  desc "search SEARCH", "Search for partially matched string"

  def search(search)
    puts 'Searching for a name with "' + search + '" in clients'
    regex = Regexp.new(search, Regexp::IGNORECASE)

    matches = @data.select { |client| client['full_name'].match?(regex) }

    if matches.empty?
      puts "No clients found"
    else
    puts "Here are the matched clients: #{JSON.pretty_generate(matches)}"
    end
  end
end

ShiftcareCli.start(ARGV)