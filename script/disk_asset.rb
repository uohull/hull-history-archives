class DiskAsset 
  attr_accessor :path, :asset_name, :is_directory, :fedora_pid

  def initialize(path, is_directory, fedora_pid)
 	@path, @is_directory, @fedora_pid = path, is_directory, fedora_pid
 	@asset_name = @path[@path.rindex('/') + 1, @path.length]
  end

  def to_s
  	"#{@asset_name} | Fedora PID: #{@fedora_pid}"
  end

end
