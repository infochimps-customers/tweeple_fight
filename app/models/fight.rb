Fight = Struct.new(:topic_1, :topic_2) do

  def self.from_hash hsh
    new(* hsh.values_at(*members))
  end

  def connection
  end

end

