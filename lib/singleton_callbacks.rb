module SingletonCallbacks

  ROOT = File.expand_path(File.join(File.dirname(__FILE__),'..'))
  LOAD_TARGET = File.expand_path(File.join(ROOT,'lib','singleton_callbacks','**/*.rb'))

  def _load
    Dir[LOAD_TARGET].each do |file| require(file) end
  end

  _load

end