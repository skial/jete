jete
====

> Haitian Creole for cast.

## Installation

With haxelib git.
	
```hxml
haxelib git klas https://github.com/skial/jete master src
```

With haxelib local.
	
```hxml
# Download the archive.
https://github.com/skial/jete/archive/master.zip

# Install archive contents.
haxelib local master.zip
```

## API

### [Jete] API

```Haxe
class Jete {
	
	public static macro function typeof(field:Expr):ExprOf<Array<ComplexType>>;
	public static macro function arity(field:Expr):ExprOf<Int>;
	public static function coerce(type:ComplexType, value:Dynamic):Dynamic;
	
}
```

Note that all variables will return `-1` for `Jete.arity`;

## Usage

Currently there are two meta tags that jete looks for, `arity` and
`type`. You can use either meta tag on any field, variable or function.

For convience, using `@:type` or `@:arity` on a class will apply
`@type` or `@arity` to every variable and method in the class.

Take note of the colon, `:`, in the meta tags when applied on a 
class. This indicates it exists at *compile time*, whereas
meta without a colon exist at *runtime*.

```Haxe
package ;

@:arity @:type class Main {
	
	public function new() {}
	public function log(value:string):Void trace(value);
	public static function add(a:Int, b:Int):Int return a + b;
	
	public static function main() {
		trace( Jete.arity( Main.add ) );	// 2
		trace( Jete.arity( Main.new.log ) );	// 1
		trace( Jete.arity( Sub.new.name ) );	// -1
		
		trace( Jete.typeof( Main.add )[0].match( macro:Int ) );	// true
		trace( Jete.typeof( Main.add )[1].match( macro:String ) );	// false
		trace( Jete.typeof( Main.add )[2].match( macro:Int ) );	// true
	}
	
}

class Sub {
	
	@arity @type public var name:String;
	public function new() {}
	
}
```

In the above example you can see `Jete.arity( Main.add )` and 
`Jete.arity( Main.new.log )`, why? 

`Jete.arity` and `Jete.typeof` can not tell the difference between
static and instance field access. Adding `new` between your class
and field name just helps differentiate between the two.