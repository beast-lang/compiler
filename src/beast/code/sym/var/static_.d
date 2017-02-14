module beast.code.sym.var.static_;

import beast.code.sym.toolkit;
import beast.code.sym.var.variable;

/// User (programmer) defined variable
abstract class Symbol_StaticVariable : Symbol_Variable {

public:
	this( Namespace parentNamespace ) {
		parentNamespace_ = parentNamespace;
	}

public:
	final override @property DeclType declarationType( ) {
		return DeclType.staticVariable;
	}

	final override @property Namespace parentNamespace( ) {
		return parentNamespace_;
	}

public:
	final override @property DataEntity data( DataEntity parentInstance ) {
		return new class DataEntity {

		public:
			this( ) {
				// Static variables are in global scope
				super( null );
			}

		public:
			override @property Symbol_Type dataType( ) {
				return dataType;
			}

			override @property bool isCtime( ) {
				return false;
			}

			override @property Identifier identifier( ) {
				return this.outer.identifier;
			}

			override @property string identificationString( ) {
				return this.outer.identificationString;
			}

		};
	}

private:
	Namespace parentNamespace_;

}
