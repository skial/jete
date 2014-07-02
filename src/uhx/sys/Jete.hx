package uhx.sys;

import haxe.macro.Expr.Expr;
import haxe.macro.Expr.ComplexType;

/**
 * ...
 * @author Skial Bainn
 */
class Jete {
	
	#if macro
	
	public static function coerce(type:ComplexType, value:Expr):Expr {
		return switch (type) {
			case TPath( { name:'Bool', pack:_, params:_, sub:_ } ):
				macro ${value}.toLowerCase() == 'true';
				
			case TPath( { name:'Float', pack:_, params:_, sub:_ } ):
				macro Std.parseFloat( $value );
				
			case TPath( { name:'Int', pack:_, params:_, sub:_ } ):
				macro Std.parseInt( $value );
				
			case TPath( { name:'Array', pack:_, params:params, sub:_ } ):
				var sub = coerce( params[0].getParameters()[0], macro v );
				macro [for (v in $value) $sub];
				
			case _:
				macro $value;
				
		}
	}
	
	#else
	
	public static function coerce(type:ComplexType, value:Dynamic):Dynamic {
		return switch (type) {
			case TPath( { name:'Bool', pack:_, params:_, sub:_ } ):
				(value:String).toLowerCase() == 'true';
				
			case TPath( { name:'Float', pack:_, params:_, sub:_ } ):
				Std.parseFloat( (value:String) );
				
			case TPath( { name:'Int', pack:_, params:_, sub:_ } ):
				Std.parseInt( (value:String) );
				
			case TPath( { name:'Array', pack:_, params:params, sub:_ } ):
				var sub = coerce.bind( params[0].getParameters()[0], _ );
				[for (v in (value:Array<String>)) sub( v )];
				
			case _:
				value;
				
		}
	}
	
	#end
	
}