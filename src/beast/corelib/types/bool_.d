module beast.corelib.types.bool_;

import beast.code.data.toolkit;
import beast.code.data.type.staticclass;
import beast.code.data.entitycontainer.namespace.bootstrap;

final class Symbol_Type_Bool : Symbol_StaticClassType {

public:
	this() {
		namespace_ = new BootstrapNamespace( this, null );
		namespace_.initialize( null );
	}

public:
	override Identifier identifier( ) {
		return Identifier.preobtained!"Bool";
	}

	override size_t instanceSize( ) {
		return 1;
	}

	override Namespace namespace( ) {
		return namespace_;
	}

public:
	// TODO: more stuff

private:
	BootstrapNamespace namespace_;

}
