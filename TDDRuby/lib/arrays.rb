class Array
  def my_uniq
    [].tap do |new_array|
      each do |elem|
        new_array << elem unless new_array.include?(elem)
      end
    end
  end

  def two_sum
    index_array = []
    each_with_index do |elem, idx|
      (idx+1...length).each do |idx2|
        index_array << [idx, idx2] if elem == -self[idx2]
      end
    end

    index_array
  end

  def my_transpose
    return [] if empty?

    new_array = Array.new(first.length) { Array.new(length)}
    each_index do |row_index|
      first.each_index do |col_index|
        new_array[col_index][row_index] = self[row_index][col_index]
      end
    end

    new_array
  end

  def stock_picker
    return nil if empty?

    best_sell   = 0
    best_buy    = 0
    best_profit = 0

    each_with_index do |buy_price, buy_date|
      ((buy_date+1)...length).each do |sell_date|
        sell_price = self[sell_date]
        if sell_price - buy_price > best_profit
          best_buy = buy_date
          best_sell = sell_date
          best_profit = sell_price - buy_price
        end
      end
    end

    [best_buy, best_sell]
  end
end
