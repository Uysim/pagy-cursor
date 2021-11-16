require "spec_helper"
require "pagy_cursor/pagy/extras/cursor"

RSpec.describe Pagy::Backend do

  let(:backend) { TestController.new }

  context 'no records' do
    it 'returns an empty collection' do
      pagy, records = backend.send(:pagy_cursor, User.all)
      expect(records).to be_empty
      expect(pagy.has_more?).to eq(false)
    end
  end

  context 'with records' do
    before do
      User.destroy_all
      1.upto(100) do |i|
        User.create!(name: "user#{i}")
      end
    end

    it "paginates with defaults" do
      pagy, records = backend.send(:pagy_cursor, User.all)
      expect(records.map(&:name)).to eq(
        ["user100", "user99", "user98", "user97", "user96",
         "user95", "user94", "user93", "user92", "user91",
         "user90", "user89", "user88", "user87", "user86",
         "user85", "user84", "user83", "user82", "user81"])
      expect(pagy.has_more?).to eq(true)
    end

    it "paginates with before" do
      record = User.find_by! name: "user30"
      pagy, records = backend.send(:pagy_cursor, User.all, before: record.id)
      expect(records.first.name).to eq("user29")
      expect(records.last.name).to eq("user10")
      expect(pagy.has_more?).to eq(true)
    end

    it "paginates with before nearly starting" do
      record = User.find_by! name: "user5"
      pagy, records = backend.send(:pagy_cursor, User.all, before: record.id)
      expect(records.first.name).to eq("user4")
      expect(records.last.name).to eq("user1")
      expect(pagy.has_more?).to eq(false)
    end

    it "paginates with after" do
      record = User.find_by! name: "user30"
      pagy, records = backend.send(:pagy_cursor, User.all, after: record.id)
      expect(records.first.name).to eq("user31")
      expect(records.last.name).to eq("user50")
      expect(pagy.has_more?).to eq(true)
    end

    it "paginates with after nearly ending" do
      record = User.find_by! name: "user90"
      pagy, records = backend.send(:pagy_cursor, User.all, after: record.id)
      expect(records.first.name).to eq("user91")
      expect(records.last.name).to eq("user100")
      expect(pagy.has_more?).to eq(false)
    end
  end

  context 'with ordered records' do
    before do
      User.destroy_all
      1.upto(100) do |i|
        User.create!(name: "user#{i}")
      end
      sleep 1
      user = User.find_by name: "user81"
      user.update(name: "I am user81")
    end

    it "paginates with defaults" do
      pagy, records = backend.send(
        :pagy_cursor,
        User.all,
        order: {
          updated_at: :desc
        }
      )

      expect(records.map(&:name)).to eq(
        ["I am user81", "user100", "user99", "user98", "user97", "user96",
         "user95", "user94", "user93", "user92", "user91",
         "user90", "user89", "user88", "user87", "user86",
         "user85", "user84", "user83", "user82"])
      expect(pagy.has_more?).to eq(true)
      expect(pagy.order[:updated_at]).to eq(:desc)
    end
  end
end
