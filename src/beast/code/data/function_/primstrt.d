/// PRIMitive STatic RunTime
module beast.code.data.function_.primstrt;

import beast.code.data.function_.toolkit;
import beast.code.ast.decl.env;
import beast.code.data.var.local;
import beast.backend.common.primitiveop;

/// Primitive (compiler-defined, handled by backend) static runtime (non-templated) function
final class Symbol_PrimitiveStaticRuntimeFunction : Symbol_RuntimeFunction {

	public:
		this( Identifier identifier, DataEntity parent, Symbol_Type returnType, ExpandedFunctionParameter[ ] parameters, BackendPrimitiveOperation op ) {
			staticData_ = new Data( this );

			identifier_ = identifier;
			parent_ = parent;
			returnType_ = returnType;
			parameters_ = parameters;
			op_ = op;
		}

		override Identifier identifier( ) {
			return identifier_;
		}

		override Symbol_Type returnType( ) {
			return returnType_;
		}

		override ExpandedFunctionParameter[ ] parameters( ) {
			return parameters_;
		}

		override DeclType declarationType( ) {
			return DeclType.memberFunction;
		}

	public:
		override DataEntity dataEntity( DataEntity parentInstance = null ) {
			return staticData_;
		}

	protected:
		override void buildDefinitionsCode( CodeBuilder cb, StaticMemberMerger staticMemberMerger ) {
			// Do nothing
		}

	private:
		Identifier identifier_;
		DataEntity parent_;
		Symbol_Type returnType_;
		Data staticData_;
		ExpandedFunctionParameter[ ] parameters_;
		BackendPrimitiveOperation op_;

	protected:
		final class Data : super.Data {

			public:
				this( Symbol_PrimitiveStaticRuntimeFunction sym ) {
					super( sym );

					sym_ = sym;
				}

			public:
				override DataEntity parent( ) {
					return sym_.parent_;
				}

				override CallableMatch startCallMatch( AST_Node ast ) {
					return new Match( sym_, this, ast );
				}

			private:
				Symbol_PrimitiveStaticRuntimeFunction sym_;

		}

		final class Match : super.Match {

			public:
				this( Symbol_PrimitiveStaticRuntimeFunction sym, Data sourceEntity, AST_Node ast ) {
					super( sym, sourceEntity, ast );

					sym_ = sym;
				}

			protected:
				override DataEntity _toDataEntity( ) {
					return new MatchData( sym_, this );
				}

			private:
				Symbol_PrimitiveStaticRuntimeFunction sym_;

		}

		final class MatchData : super.MatchData {

			public:
				this( Symbol_PrimitiveStaticRuntimeFunction sym, Match match ) {
					super( sym, match );

					sym_ = sym;
				}

			public:
				override void buildCode( CodeBuilder cb ) {
					cb.build_primitiveOperation( sym_, op_, null, arguments_ );
				}

			private:
				Symbol_PrimitiveStaticRuntimeFunction sym_;

		}

}