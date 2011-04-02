Thingy = Struct.new(:name, :content, :active) do

  def self.from_hash hsh
    new(* hsh.values_at(*members))
  end
end

