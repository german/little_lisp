require_relative '../little_lisp.rb'

describe LittleLisp do
  before { @lli = LittleLisp.new }
  
  it "makes basic lambda calls" do
    @lli.interpret( '((lambda (x)
      x)
      "Lisp")' ).should == "Lisp"
 
    @lli.interpret( '((lambda(x y) x) "Lisp" "notdead")' ).should == "Lisp"
    @lli.interpret( '((lambda(x y) y) "Lisp" "notdead")' ).should == "notdead"
  end

  it "performs basic arithmetic operations" do
    @lli.interpret( '((lambda(x) (+ x 2)) 2)' ).should == 4.0
    @lli.interpret( '((lambda(x y) (+ x y)) 2 5)' ).should == 7.0
    @lli.interpret( '((lambda(x y z) (* x (+ z y))) 10 5 2)').should == 70.0
    @lli.interpret( '((lambda(x y) (* y (+ x 2))) 2 5)' ).should == 20.0
    @lli.interpret( '((lambda(x y) (* x (+ 2 y))) 2 5)' ).should == 14.0
    @lli.interpret( '((lambda(x y) (+ x (* 2 y))) 2 5)' ).should == 12.0
  end

  it "has basic logic operators" do
    @lli.interpret( '(> 2 5)' ).should == false
    @lli.interpret( '(> 10 1)' ).should == true
    @lli.interpret( '(< 2 5)' ).should == true
    @lli.interpret( '(< (+ 10 1) (* 3 4))' ).should == true
  end
  
  it "has `if` control structure" do
    @lli.interpret( '(if (> 10 1) 10 1)' ).should == 10.0
    #@lli.interpret( '(if (< (* 10 2) (+ 5 9)) "14 greater then 20" "20 greater then 14")' ).should == "20 greater then 14"
    @lli.interpret( '(if (< (* 10 2) (+ 5 9)) 1 0)' ).should == 0.0
  end
end
