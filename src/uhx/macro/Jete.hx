package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.Serializer;
import uhx.macro.KlasImp;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 * Haitian Creole for Cast
 */
class Jete {

	public static macro function initialize():Void {
		try {
			KlasImp.initalize();
			KlasImp.CLASS_META.set(':rtti', Jete.classHandler);
			KlasImp.FIELD_META.set(':rtti', Jete.fieldHandler);
			
			KlasImp.CLASS_META.set('arity', Jete.classArityHandler);
			KlasImp.FIELD_META.set('arity', Jete.fieldArityHandler);
			
			KlasImp.CLASS_META.set('type', Jete.classTypeHandler);
			KlasImp.FIELD_META.set('type', Jete.fieldTypeHandler);
		} catch (e:Dynamic) {
			// This assumes that `implements Klas` is not being used
			// but `@:autoBuild` or `@:build` metadata is being used 
			// with the provided `uhx.sys.Jete.build()` method.
		}
	}
	
	public static build():Array<Field> {
		return handler( Context.getLocalClass().get(), Context.getBuildFields() );
	}
	
	public static function classHandler(cls:ClassType, fields:Array<Field>):Array<Field> {
		return fields
			.map( function(f) {
				f.meta.push( { name:'type', pos:f.pos } );
				f.meta.push( { name:'arity', pos:f.pos } );
				return f;
			} )
			.map( fieldHandler.bind( cls, _ ) );
	}
	
	public static function fieldHandler(cls:ClassType, field:Field):Field {
		field.meta.push( { name:'type', pos:f.pos } );
		field.meta.push( { name:'arity', pos:f.pos } );
		
		return fieldArityHandler( cls, fieldTypeHandler( cls, field ) );
	}
	
	public static function classArityHandler(cls:ClassType, fields:Array<Field>):Array<Field> {
		return fields.map( fieldArityHandler.bind( cls, _ ) );
	}
	
	public static function fieldArityHandler(cls:ClassType, field:Field):Field {
		var meta = field.meta.filter( function(m) return m.name == 'arity' );
		
		if (meta.length > 0) {
			
			switch (field.kind) {
				case FVar(_, _), FProp(_, _, _, _):
					meta[0].params.push( macro -1 );
					
				case FFun(m):
					var arity = m.args.length;
					meta[0].params.push( macro $arity );
					
			}
			
		}
		
		return field;
	}
	
	public static function classTypeHandler(cls:ClassType, fields:Array<Field>):Array<Field> {
		return fields.map( fieldTypeHandler.bind( cls, _ ) );
	}
	
	public static function fieldTypeHandler(cls:ClassType, field:Field):Field {
		var meta = field.meta.filter( function(m) return m.name == 'type' );
		
		if (meta.length > 0) {
			
			Serializer.USE_CACHE = true;
			
			switch (field.kind) {
				case FVar(t, _), FProp(_, _, t, _):
					meta[0].params.push( Serializer.run( [t] ) );
					
				case FFun(m):
					var types = [for (a in m.args) a.type];
					types.push( m.ret );
					
					meta[0].params.push( Serializer.run( types ) );
					
			}
			
		}
		
		return field;
	}
	
}