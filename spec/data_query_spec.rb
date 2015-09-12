require_relative "../src/data_query.rb"
require_relative "../src/user.rb"

def build_users(count)
  (1..count).each_with_object([]) do |i, users|
    users << User.new(i.even?, i % 2, i % 3, i % 4, i % 5)
  end
end

describe "SimpleDataIndexer" do
  let(:indexer) { SimpleDataIndexer.new(build_users(10), User.members) }

  context "search with index" do
    before(:each) { indexer.create_index(:height) }
    after(:each) { indexer.drop_index(:height) }

    it { expect(indexer.index?(:height)).to be true }

    it { expect(indexer.search(height: 0).count).to be 3 }
    it { expect(indexer.search(height: 1).count).to be 4 }
    it { expect(indexer.search(height: 2).count).to be 3 }

    it { expect(indexer.search(height: 0..1).count).to be 7 }
    it { expect(indexer.search(height: 1..2).count).to be 7 }
    it { expect(indexer.search(height: 0..2).count).to be 10 }
  end

  context "search without index" do
    it { expect(indexer.search(age: 0).count).to be 5 }
    it { expect(indexer.search(age: 1).count).to be 5 }
    it { expect(indexer.search(age: 0..1).count).to be 10 }
  end
end
