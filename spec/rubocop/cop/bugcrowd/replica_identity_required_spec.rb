# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::ReplicaIdentityRequired do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  context 'when creating a table' do
    context 'without calling set_replica_identity' do
      it 'does register an offense' do
        expect_offense(<<~RUBY)
          def up
            create_table :new_table, id: :uuid do |t|
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ tables should have `set_replica_identity` called after `create_table`, probably with set_replica_identity(:table_name, :full)
            end
          end
        RUBY
      end
    end
    context 'with calling set_replica_identity' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          def up
            create_table :new_table, id: :uuid do |t|
              t.text :name, null: false
            end
            set_replica_identity(:full)
          end
        RUBY
      end
    end
  end
end
