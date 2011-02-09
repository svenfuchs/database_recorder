require 'test_helper'

class DatabaseRecorderTest < Test::Unit::TestCase
  def setup
    DatabaseRecorder.start!
    super
  end

  def teardown
    DatabaseRecorder.stop! rescue nil
    super
  end

  def recorder
    DatabaseRecorder.instance
  end

  test 'replaying a bunch of queries' do
    3.times do
      entry = Entry.create!                  # should be in state #1 now
      assert entry.is_a?(Entry)

      entries = Entry.all                    # should have recorded a select query for state #1
      assert_equal 1, entries.size
      assert entries.first.is_a?(Entry)

      entry = Entry.create!                  # should be in state #2 now
      assert entry.is_a?(Entry)

      entries = Entry.all                    # should have recorded a select query for state #2
      assert_equal 2, entries.size
      assert entries.first.is_a?(Entry)
puts
p DatabaseRecorder.instance.instance_variable_get(:@results)
puts
      DatabaseRecorder.save
      DatabaseRecorder.stop!
      DatabaseRecorder.start!
      DatabaseRecorder.replay!
    end
  end

  test 'autoincremented primary keys' do
    2.times do
      assert_equal 1, Entry.create!.id
      assert_equal 2, Entry.create!.id
      assert_equal 3, Entry.create!.id

      DatabaseRecorder.save
      DatabaseRecorder.stop!
      DatabaseRecorder.start!
      DatabaseRecorder.replay!
    end
  end

  test 'storing and reloading state' do
    Entry.all
    results = recorder.send(:results)
    recorder.save
    recorder.instance_variable_set(:@results, nil)
    recorder.load
    assert_equal recorder.send(:results), results
  end
end
