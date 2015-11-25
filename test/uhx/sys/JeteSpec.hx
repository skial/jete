package uhx.sys;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

/**
 * ...
 * @author Skial Bainn
 */
class JeteSpec {
	
	@type @arity public static function main() {
		var runner = new Runner();
		runner.addCase( new JeteSpec() );
		Report.create( runner );
		runner.run();
	}
	
	@arity @type public function ction(a:String) return a;

	public function new() {
		var helper = new JeteSpecHelper();
		
	}
	
}

@:arity @:type class JeteSpecHelper {
	
	public function new() {
		
	}
	
	public function fun(a:Int, b:Int, c:Int, d:Int, e:Int):Array<Int> {
		return [a, b, c, d, e];
	}
	
}