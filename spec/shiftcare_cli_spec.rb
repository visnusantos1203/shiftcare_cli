require "rspec"
require "json"
require_relative "../shiftcare_cli"

RSpec.describe ShiftcareCli do
  let(:cli) { ShiftcareCli.new }

  before do
    json_data = [
      { "full_name" => "Alice Johnson", "email" => "alice@example.com" },
      { "full_name" => "Bob Smith", "email" => "bob@example.com" },
      { "full_name" => "Charlie Appleton", "email" => "charlie@example.com" },
      { "full_name" => "David Doe", "email" => "alice@example.com" } # Duplicate email
    ]

    # Stub file reading and parsing
    allow(File).to receive(:read).with("clients.json").and_return(json_data.to_json)
    allow(JSON).to receive(:parse).and_return(json_data)
  end

  describe "#search" do
    it "returns clients with names partially matching the query" do
      expect { cli.search("Alice") }.to output(/Alice Johnson/).to_stdout
    end

    it "performs case-insensitive matching" do
      expect { cli.search("alice") }.to output(/Alice Johnson/).to_stdout
    end

    it "returns no matches when there are none" do
      expect { cli.search("Zach") }.to output(/No clients found/).to_stdout
    end
  end
end
