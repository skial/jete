package uhx.sys;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
#end

import haxe.macro.Expr.Expr;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Printer;

/**
 * ...
 * @author Skial Bainn
 */
class Jete {
	
	public static macro function typeof(field:Expr):ExprOf<Array<ComplexType>> {
		switch (field) {
			case macro $c.$f if (c.expr.match( EConst(CIdent(_)) )):	// static access
				return macro (haxe.Unserializer.run( haxe.rtti.Meta.getStatics( $c ).$f.type[0] ):Array<ComplexType>);
				
			case macro $c.new.$f:	// instance access
				return macro (haxe.Unserializer.run( haxe.rtti.Meta.getFields( $c ).$f.type[0] ):Array<ComplexType>);
				
			case _:
				
		}
		
		return macro [];
	}
	
	public static macro function arity(field:Expr):ExprOf<Int> {
		switch (field) {
			case macro $c.$f if (c.expr.match( EConst(CIdent(_)) )):	// static access
				return macro (haxe.rtti.Meta.getStatics( $c ).$f.arity[0]:Int);
				
			case macro $c.new.$f:	// instance access
				return macro (haxe.rtti.Meta.getFields( $c ).$f.arity[0]:Int);
				
			case _:
				
		}
		
		return macro -1;
	}
	
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