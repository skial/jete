package uhx.sys;

import haxe.Unserializer;
import utest.Assert;
import utest.Runner;
import haxe.rtti.Meta;
import utest.ui.Report;
import haxe.macro.Expr.ComplexType;

/**
 * ...
 * @author Skial Bainn
 */
class JeteSpec {
	
	public static function main() {
		var runner = new Runner();
		runner.addCase( new JeteSpec() );
		Report.create( runner );
		runner.run();
	}
	
	@arity @type public function ction(a:String) return a;

	public var helper:JeteSpecHelper;
	
	public function new() {
		helper = new JeteSpecHelper();
	}
	
	public function testArity() {
		var meta = Meta.getFields( JeteSpec ).ction;
		Assert.equals( 1, meta.arity[0] );
		
		var meta = Meta.getFields( JeteSpecHelper ).fun;
		Assert.equals( 5, meta.arity[0] );
	}
	
	public function testType() {
		var meta = Meta.getFields( JeteSpec ).ction;
		Assert.isTrue( (Unserializer.run( meta.type[0] ):Array<ComplexType>)[0].match( macro:String ) );
		
		var meta = Meta.getFields( JeteSpecHelper ).fun;
		Assert.isTrue( (Unserializer.run( meta.type[0] ):Array<ComplexType>)[0].match( macro:Int ) );
		Assert.isTrue( (Unserializer.run( meta.type[0] ):Array<ComplexType>)[1].match( macro:Int ) );
		Assert.isTrue( (Unserializer.run( meta.type[0] ):Array<ComplexType>)[2].match( macro:Int ) );
		Assert.isTrue( (Unserializer.run( meta.type[0] ):Array<ComplexType>)[3].match( macro:Int ) );
		Assert.isTrue( (Unserializer.run( meta.type[0] ):Array<ComplexType>)[4].match( macro:Int ) );
		Assert.isTrue( (Unserializer.run( meta.type[0] ):Array<ComplexType>)[5].match( macro:Array<Int> ) );
	}
	
}

@:arity @:type class JeteSpecHelper {
	
	public function new() {
		
	}
	
	public function fun(a:Int, b:Int, c:Int, d:Int, e:Int):Array<Int> {
		return [a, b, c, d, e];
	}
	
}