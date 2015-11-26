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
			KlasImp.initialize();
			KlasImp.classMetadata.add( ':arity', Jete.classHandler );
			KlasImp.classMetadata.add( ':type', Jete.classHandler );
			
			KlasImp.fieldMetadata.add( ':arity', Jete.fieldHandler );
			KlasImp.fieldMetadata.add( ':type', Jete.fieldHandler );
			
			KlasImp.classMetadata.add( 'arity', Jete.classArityHandler );
			KlasImp.fieldMetadata.add( 'arity', Jete.fieldArityHandler );
			
			KlasImp.classMetadata.add( 'type', Jete.classTypeHandler );
			KlasImp.fieldMetadata.add( 'type', Jete.fieldTypeHandler );
		} catch (e:Dynamic) {
			// This assumes that `implements Klas` is not being used
			// but `@:autoBuild` or `@:build` metadata is being used 
			// with the provided `uhx.sys.Jete.build()` method.
		}
	}
	
	public static function build():Array<Field> {
		return classHandler( Context.getLocalClass().get(), Context.getBuildFields() );
	}
	
	public static function classHandler(cls:ClassType, fields:Array<Field>):Array<Field> {
		return fields
			.map( function(f) {
				if (f.meta.filter( function(m) return m.name == 'type' ).length == 0) {
					f.meta.push( { name:'type', params:[], pos:f.pos } );
					
				}
				
				if (f.meta.filter( function(m) return m.name == 'arity' ).length == 0) {
					f.meta.push( { name:'arity', params:[], pos:f.pos } );
					
				}
				
				return f;
			} )
			.map( fieldHandler.bind( cls, _ ) );
	}
	
	public static function fieldHandler(cls:ClassType, field:Field):Field {
		if (field.meta.filter( function(m) return m.name == 'type' ).length == 0) {
			field.meta.push( { name:'type', params:[], pos:field.pos } );
			
		}
		
		if (field.meta.filter( function(m) return m.name == 'arity' ).length == 0) {
			field.meta.push( { name:'arity', params:[], pos:field.pos } );
			
		}
		
		return fieldArityHandler( cls, fieldTypeHandler( cls, field ) );
	}
	
	public static function classArityHandler(cls:ClassType, fields:Array<Field>):Array<Field> {
		return fields.map( fieldArityHandler.bind( cls, _ ) );
	}
	
	public static function fieldArityHandler(cls:ClassType, field:Field):Field {
		var meta = field.meta.filter( function(m) return m.name == 'arity' && m.params.length == 0 );
		
		if (meta.length > 0) {
			
			switch (field.kind) {
				case FVar(_, _), FProp(_, _, _, _):
					meta[0].params.push( macro -1 );
					
				case FFun(m):
					var arity = m.args.length;
					meta[0].params.push( macro $v { arity } );
					
			}
			
		}
		
		return field;
	}
	
	public static function classTypeHandler(cls:ClassType, fields:Array<Field>):Array<Field> {
		return fields.map( fieldTypeHandler.bind( cls, _ ) );
	}
	
	public static function fieldTypeHandler(cls:ClassType, field:Field):Field {
		var meta = field.meta.filter( function(m) return m.name == 'type' && m.params.length == 0 );
		
		if (meta.length > 0) {
			
			Serializer.USE_CACHE = true;
			
			switch (field.kind) {
				case FVar(t, _), FProp(_, _, t, _):
					meta[0].params.push( macro $v { Serializer.run( [t] ) } );
					
				case FFun(m):
					var types = [for (a in m.args) a.type];
					types.push( m.ret );
					
					meta[0].params.push( macro $v { Serializer.run( types ) } );
					
			}
			
		}
		
		return field;
	}
	
}