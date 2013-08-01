def tokenize input
  input.gsub(/\(/, ' ( ').gsub(/\)/, ' ) ').strip.split(/\s+/)
end

def parenthesize(input, list = [])  
  token = input.shift

  if token == nil
    list.pop
  elsif token === "("
    list.push(parenthesize(input, []))
    parenthesize(input, list)      
  elsif token === ")"
    list
  else
    parenthesize(input, list.push(categorize(token)) )
  end
end

def categorize input
  { type: 'literal', value: Float(input) }
rescue ArgumentError
  if input[0] === '"' && input.slice(-1) === '"'
    { type: 'literal', value: input[1...-1] }
  else
    { type:'identifier', value: input }
  end
end

class Context
  def initialize(scope, parent = nil)
    @scope = scope
    @parent = parent
  end
  
  def get identifier
    if @scope[identifier]
      @scope[identifier]
    elsif @parent
      @parent.get identifier
    end
  end
end

SPECIAL = {
  'lambda' => proc do |input, context|
    proc do |*args|
      lambdaArguments = args.flatten
      lambdaScope = {}
      input[1].to_enum.with_index.each do |x, i|
        lambdaScope[x[:value]] = lambdaArguments[i]
      end
      interpret(input[2], Context.new(lambdaScope, context))
    end
  end
}

def interpretList(input, context)
  if input[0] && input[0].is_a?(Hash) && SPECIAL[input[0][:value]]
    SPECIAL[input[0][:value]].call(input, context)
  else
    list = input.map{|x| interpret(x, context) }
    if list[0].is_a?(Proc)
      list[0].call(list[1..-1])
    else
      list
    end
  end
end

def interpret(input, context = nil)  
  if context === nil
    interpret(input, Context.new({}))
  elsif input.is_a?(Array)
    interpretList(input, context);
  elsif input[:type] === "identifier"
    context.get(input[:value])
  else
    input[:value]
  end
end

input = '((lambda (x)
  x)
 "Lisp")'

puts interpret(parenthesize(tokenize(input))).inspect
