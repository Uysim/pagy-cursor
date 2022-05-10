require "spec_helper"
require "pagy_cursor/pagy/extras/uuid_cursor"

RSpec.describe PagyCursor do
  let(:backend) { TestController.new }

  context 'no records' do
    it 'returns an empty collection' do
      pagy, records = backend.send(:pagy_uuid_cursor, Post.all)
      expect(records).to be_empty
      expect(pagy.has_more?).to eq(false)
    end
  end

  context 'with records' do
    before do
      Post.destroy_all
      1.upto(100) do |i|
        Post.create!(title: "post#{i}", created_at: (100-i).minutes.ago)
      end
    end

    it "paginates with defaults" do
      pagy, records = backend.send(:pagy_uuid_cursor, Post.all)
      expect(records.map(&:title)).to eq(
        ["post100", "post99", "post98", "post97", "post96",
         "post95", "post94", "post93", "post92", "post91",
         "post90", "post89", "post88", "post87", "post86",
         "post85", "post84", "post83", "post82", "post81"])
      expect(pagy.has_more?).to eq(true)
      expect(pagy.next_position).to eq(records.last.id)
    end

    it "paginates with before" do
      record = Post.find_by! title: "post30"
      pagy, records = backend.send(:pagy_uuid_cursor, Post.all, before: record.id)
      expect(records.first.title).to eq("post29")
      expect(records.last.title).to eq("post10")
      expect(pagy.has_more?).to eq(true)
      expect(pagy.next_position).to eq(records.last.id)
    end

    it "paginates with before nearly starting" do
      record = Post.find_by! title: "post5"
      pagy, records = backend.send(:pagy_uuid_cursor, Post.all, before: record.id)
      expect(records.first.title).to eq("post4")
      expect(records.last.title).to eq("post1")
      expect(pagy.has_more?).to eq(false)
      expect(pagy.next_position).to be(nil)
    end

    it "paginates with after" do
      record = Post.find_by! title: "post30"
      pagy, records = backend.send(:pagy_uuid_cursor, Post.all, after: record.id)
      expect(records.first.title).to eq("post31")
      expect(records.last.title).to eq("post50")
      expect(pagy.has_more?).to eq(true)
      expect(pagy.next_position).to eq(records.last.id)
    end

    it "paginates with before nearly starting" do
      record = Post.find_by! title: "post90"
      pagy, records = backend.send(:pagy_uuid_cursor, Post.all, after: record.id)
      expect(records.first.title).to eq("post91")
      expect(records.last.title).to eq("post100")
      expect(pagy.has_more?).to eq(false)
      expect(pagy.next_position).to be(nil)
    end

    it 'returns a chainable relation' do
      _, records = backend.send(:pagy_cursor, User.all)
 
      expect(records).to be_a(ActiveRecord::Relation)
    end
  end

  context 'with ordered records' do
    before do
      Post.destroy_all
      1.upto(100) do |i|
        Post.create!(title: "post#{i}", created_at: (100-i).minutes.ago)
      end
      sleep 1 # delay for mysql timestamp
      post = Post.find_by(title: "post91")
      post.update(title: "This is post91")
    end

    it "paginates with defaults" do
      pagy, records = backend.send(
        :pagy_uuid_cursor,
        Post.all,
        order: {
          updated_at: :desc
        }
      )
      expect(records.map(&:title)).to eq(
        ["This is post91", "post100", "post99", "post98", "post97", "post96",
         "post95", "post94", "post93", "post92",
         "post90", "post89", "post88", "post87", "post86",
         "post85", "post84", "post83", "post82", "post81"])
      expect(pagy.has_more?).to eq(true)
      expect(pagy.next_position).to eq(records.last.id)
      expect(pagy.order[:updated_at]).to eq(:desc)
    end
  end
end
