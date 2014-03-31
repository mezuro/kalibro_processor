class Language < ActiveRecord::Base
  enum name: [ :C, :CPP, :JAVA, :PYTHON ] #FIXME turn CPP to "C++" as in Kalibro
end