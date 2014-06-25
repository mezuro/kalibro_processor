class Runner
  attr_accessor :repository

  def initialize(repository)
    @repository = repository
  end

  def run
    processing = Processing.create(repository: self.repository, state: "LOADING")
    generate_dir_name
  end

  private

  def generate_dir_name
    path = YAML.load_file("#{Rails.root}/config/repositories.yml")["repositories"]["path"]
    dir = path
    raise RunTimeError if !Dir.exists?(dir)
    while Dir.exists?(dir)
      dir = "#{path}/#{Digest::MD5.hexdigest(Time.now.to_s)}"
    end
  end
end