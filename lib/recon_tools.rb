# https://dev.to/exampro/testunit-writing-test-code-in-ruby-part-1-of-3-44m2

class ReconTools
  attr_reader :array_data_in1, :array_data_in2,
    :new_records, :deleted_records, :updated_records, :matched_records, :duplicate_data1_records, :duplicate_data2_records,
    :updated_array, :updates, :changelog

  def hello_world_test()
    puts "Hello World"
  end

  def  initialize(array_data_in1, array_data_in2)
    @data_in1 = {}
    @data_in2 = {}
    @matched_records = {}
    @updated_records = {}
    @new_records = {}
    @deleted_records = {}
    @duplicate_data1_records = []
    @duplicate_data2_records = []
    @updated_array = []
    @updates = []

    @array_data_in1 = array_data_in1
    @array_data_in2 = array_data_in2
    @data_in1, @duplicate_data1_records = importArray(array_data_in1)
    @data_in2, @duplicate_data2_records = importArray(array_data_in2)

    @matched_records, @updated_records = get_matching_records(@data_in1, @data_in2)
    @new_records = get_only_in_datain1_records(@data_in1, @data_in2)
    @deleted_records = get_only_in_datain1_records(@data_in2, @data_in1)
    @updated_array, @changelog =  update_data(@array_data_in1)
    @updates = generate_updates(@updated_array)
    #@deleted_records = get_deleted_records(@data_in1, @data_in2)
  end

  # Remove duplicates and collect list of duplicates
  def importArray(arrayIn)
    data_hash = {}
    duplicates =  []
    arrayIn.each{ |record|
      if data_hash.key?(record[0])
        duplicates << record
      else
        data_hash[record[0]]=record
      end
    }
    return data_hash, duplicates
  end

  # Update data1 by updating records,  removing deleted ones and adding new ones
  def update_data(arrayIn)
    changelog = []
    updated_array = []
    arrayIn.each{ |record|
      if @data_in2.key?(record[0])
        #puts "updated data"
        #update changed records
        updated_array << @data_in2[record[0]]
        if @data_in2[record[0]] == record
          changelog << "No change #{record}"
        else
          changelog << "Updated from #{record}"
        end
      elsif @deleted_records.key?(record[0])
        #puts "deleted data"
        #puts Array.new record.size, ""
        #puts record
        updated_array << (Array.new record.size, "")
        changelog << "Deleted #{record}"
      end
    }
    @new_records.each { |key,value|
      changelog << "New #{value}"
      updated_array << value
    }

    return updated_array, changelog
  end

  def generate_updates(updated_array)
    updates =  []
    #updates_with_diff =  []
    updated_array.each_with_index { |val, index|
      #puts " updated_array #{val}"
      val.each_with_index { |val2, index2|
        #puts " val2 #{val2}"
        if @array_data_in1.length > index and @array_data_in1[index][index2] == val2
          #puts "matches "
          #updates  << [index, index2, val2]
        else
          #puts "doesn't matche"
          updates  << [index, index2, updated_array[index][index2]]
          #updates_with_diff << [index, index2, "Updated #{@array_data_in1[index][index2]} #{updated_array[index][index2]]}"]
        end
        }
      }
    #puts "Updates #{updates}"
    #puts "end generate_updates"
    updates #, updates_with_diff
  end

  def get_matching_records(data_in1, data_in2)
    matches = data_in1.keys.filter { |key| key if data_in2.has_key?(key) }
    matches.each { |key|
      if data_in1[key] == data_in2[key]
        matched_records[key]=data_in1[key]
      else
        updated_records[key] = data_in2[key]
      end
    }
    return matched_records, updated_records
  end

  def get_only_in_datain1_records(data_in1, data_in2)
    keys = data_in2.keys - data_in1.keys
    data1_records = {}
    keys.each { |key|
      data1_records[key]=data_in2[key]
    }
    #puts new_records
    data1_records
  end


  def get_updated_data(array1, array2)
    array1.each_with_index do |element, index|
      puts "element: #{element}, array2: #{array2[index]}, index: #{index}\n"
      puts element if element==array2[index]
    end
  end

  def debug(hash_in)
    hash_in.each_with_index do |(key, value), index|
       puts "key: #{key}, value: #{value}, index: #{index}\n"
    end
  end
end







#assert_equal dataset2, dataset1, 'Datasets should match'
