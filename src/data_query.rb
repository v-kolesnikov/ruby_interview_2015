require "dbm"
require "fileutils"

class SimpleDataIndexer
  DEFAULT_INDEX_PATH = ".index"

  attr_accessor :index_path, :indexed

  def initialize(data, fields, path = DEFAULT_INDEX_PATH)
    @data = data
    @fields = fields
    @indexed = []
    @index_path = path
    init_index_path
  end

  def create_index(field)
    return if !valid_field?(field) || index?(field)

    DBM.open(field_index_path(field)) do |db|
      @data.group_by(&field).each do |key, value|
        db[key.to_s] = Marshal.dump(value)
      end
      @indexed << field
    end
  end

  def drop_index(field)
    if index?(field)
      FileUtils.rm_f Dir.glob("#{field_index_path(field)}.*")
      @indexed.delete(field)
    end
  end

  def field_index_path(field)
    File.join @index_path, "#{field}_index"
  end

  def get_data(db, index)
    db.include?(index) ? Marshal.load(db[index]) : []
  end

  def index?(field)
    @indexed.include?(field)
  end

  def init_index_path
    FileUtils.mkdir_p @index_path
  end

  def range_value?(value)
    value.is_a?(Range) || value.is_a?(Array)
  end

  def search(query)
    indexed, direct = query.partition { |k, _| @indexed.include? k }.map(&:to_h)

    (search_by_index(indexed) | search_directly(direct)).flatten
  end

  def search_by_index(query)
    query.each_with_object([]) do |(field, value), data|
      DBM.open(field_index_path(field)) do |db|
        if range_value?(value)
          value.each { |v| data << get_data(db, v.to_s) }
        else
          data << get_data(db, value.to_s)
        end
      end
    end
  end

  def search_directly(query)
    query.each_with_object([]) do |(field, value), data|
      if range_value?(value)
        data << @data.select { |el| value.include? el.send(field) }
      else
        data << @data.select { |el| el.send(field) == value }
      end
    end
  end

  def valid_field?(field)
    @fields.include?(field)
  end
end
