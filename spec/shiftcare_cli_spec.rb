require "rspec"
require "json"
require_relative "../shiftcare_cli"

RSpec.describe ShiftcareCli do
  let(:cli) { ShiftcareCli.new }

  before do
    json_data = [
      { "full_name" => "Juan Dela Cruz", "email" => "juan@example.com" },
      { "full_name" => "Bob Smith", "email" => "bob@example.com" },
      { "full_name" => "Charlie Appleton", "email" => "charlie@example.com" },
      { "full_name" => nil, "email" => "no_name@example.com" }, # Missing full_names
      { "full_name" => "David Doe", "email" => "juan@example.com" } # Duplicate email
    ]

    # Stub file reading and parsing
    allow(File).to receive(:read).with("clients.json").and_return(json_data.to_json)
    allow(JSON).to receive(:parse).and_return(json_data)
  end

  describe "#duplicate_emails" do
    it "detects duplicate emails" do
      expect { cli.duplicate_emails }.to output(/juan@example.com/).to_stdout
    end

    it "shows no duplicates if all emails are unique" do
      allow(JSON).to receive(:parse).and_return([
        { "full_name" => "Eve Adams", "email" => "eve@example.com" },
        { "full_name" => "Frank White", "email" => "frank@example.com" }
      ])
      
      expect { cli.duplicate_emails }.to output(/No duplicate emails found/).to_stdout
    end
  end

  describe "#search" do
    it "returns clients with names partially matching the query" do
      expect { cli.search("Juan") }.to output(/Juan Dela Cruz/).to_stdout
    end

    it "performs case-insensitive matching" do
      expect { cli.search("juAN") }.to output(/Juan Dela Cruz/).to_stdout
    end

    it "returns no matches when there are none" do
      expect { cli.search("Zach") }.to output(/No clients found/).to_stdout
    end

    it "escapes regex special characters in search query" do
      expect { cli.search("J*an") }.to output(/No clients found/).to_stdout
    end

    it "handles missing full_name values gracefully" do
      expect { cli.search("no_name") }.not_to raise_error
    end
  end
end
