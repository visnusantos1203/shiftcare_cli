#!/usr/bin/env ruby
require 'json'
require "thor"

class ShiftcareCli < Thor
  def initialize(*args)
    super
    @data = validate_and_load_data
  end

  desc "duplicate_emails", "Find clients with duplicate emails"

  def duplicate_emails
    if @data.empty?
     puts "No data found."
     return
    end

    puts 'Finding clients with duplicate emails...'

    email_groups = @data.group_by { |client| client['email']&.downcase }.compact
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

  desc "search SEARCH_STRING", "Search for partially matched names in clients"

  def search(search_string)
    if search_string.strip.empty?
      puts "Error: Search query cannot be empty."
      return
    end

    puts 'Searching for a match with "' + search_string + '" in clients'

    # Utilize Regexp.escape to escape special characters in the search string
    safe_search_string = Regexp.escape(search_string)
    regex = Regexp.new(safe_search_string, Regexp::IGNORECASE)

    # Added safe navigation operator to avoid nil error
    matches = @data.select { |client| client['full_name']&.match?(regex) }

    if matches.empty?
      puts "No clients found"
    else
      puts "Here are the matched clients: #{JSON.pretty_generate(matches)}"
    end
  end

  private

  def validate_and_load_data
    unless File.exist?('clients.json')
      puts "Error: 'clients.json' file not found."
      exit(1)
    end

    json_content = File.read('clients.json').strip
    return [] if json_content.empty?

    data = JSON.parse(json_content)
    data.is_a?(Array) ? data : []
  rescue JSON::ParserError
    puts "Error: Invalid JSON format in 'clients.json'."
    exit(1)
  end
end

ShiftcareCli.start(ARGV)