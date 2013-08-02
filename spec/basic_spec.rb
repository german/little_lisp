require_relative '../little_lisp.rb'

describe LittleRuby do
  before { @lri = LittleRuby.new }
  
  it "makes basic lambda calls" do
    @lri.interpret( '((lambda (x)
      x)
      "Lisp")' ).should == "Lisp"
 
    @lri.interpret( '((lambda(x y) x) "Lisp" "notdead")' ).should == "Lisp"
    @lri.interpret( '((lambda(x y) y) "Lisp" "notdead")' ).should == "notdead"
  end

  it "performs basic arithmetic operations" do
    @lri.interpret( '((lambda(x) (+ x 2)) 2)' ).should == 4.0
    @lri.interpret( '((lambda(x y) (+ x y)) 2 5)' ).should == 7.0
    @lri.interpret( '((lambda(x y z) (* x (+ z y))) 10 5 2)').should == 70.0
    @lri.interpret( '((lambda(x y) (* y (+ x 2))) 2 5)' ).should == 20.0
    @lri.interpret( '((lambda(x y) (* x (+ 2 y))) 2 5)' ).should == 14.0
    @lri.interpret( '((lambda(x y) (+ x (* 2 y))) 2 5)' ).should == 12.0
  end
end