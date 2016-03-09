require 'daru'
require 'statsample-glm'
require 'open-uri'

module TestClass
  #
  # print "hello"
  #
  # row_holder = []
  #
  # hashi1= {}
  # hashi1["kk"] = [22]
  # hashi1["first strategy"] = [0.3]
  #
  # hashi2= {}
  # hashi2["first strategy"] = [33]
  # hashi2["kk"] = [44]
  #
  # r1 = Daru::Vector.new(hashi1)
  # r2 = Daru::Vector.new(hashi2)
  #
  # row_holder.push r2
  # row_holder.push r1
  #
  # df = Daru::DataFrame.rows(row_holder)
  #
  # print "f"

  # df = Daru::DataFrame.new([[1,2,3,4], [1,2,3,4]],order: [:a, :b], index: [:one, :two, :three, :four])


  content = open('http://www.ats.ucla.edu/stat/data/binary.csv')
  File.write('binary.csv', content.read)

  df = Daru::DataFrame.from_csv "binary.csv"
  # df.vectors = Daru::Index.new([:admit, :gpa, :gre, :rank])
  df

  glm = Statsample::GLM::compute df, :admit, :logistic, constant: 1
  c = glm.coefficients :hash

  print c

end
