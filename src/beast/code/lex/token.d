module beast.code.lex.token;

import beast.code.lex.toolkit;
import beast.core.project.codesource;
import beast.core.project.codelocation;
import beast.utility.enumassoc;
import std.algorithm;
import std.meta;

final class Token {

public:
	enum Type {
		_noToken,

		identifier,
		keyword,
		operator,
		special
	}

	static immutable string[ ] typeStr = [ "", "identifier", "keyword", "operator", "" ];

	// Ugly dmft formatting
	static immutable Data[ ] typeDefaultData = [ {identifier:
	null}, {identifier:
	null}, {keyword:
	Keyword._noKeyword}, {operator:
	Operator._noOperator}, {special:
	Special._noSpecial} ];

	enum Keyword {
		_noKeyword,

		module_,
		class_,
		if_,
		else_
	}

	static immutable string[ ] keywordStr = {
		string[ ] result;

		foreach ( memberName; __traits( derivedMembers, Keyword ) )
			result ~= memberName.endsWith( "_" ) ? memberName[ 0 .. $ - 1 ] : memberName;

		return result;
	}( );

	enum Operator {
		_noOperator,
		plus,
		minus,
		asterisk, /// '*'
		slash, /// '/'
		dollar /// '$'
	}

	static immutable string[ ] operatorStr = [ null, "+", "-", "*", "/", "$" ];

	enum Special {
		_noSpecial,
		eof,

		dot,
		semicolon, /// ';'
		colon, /// ':'

		at, /// '@'

		lBracket, /// '['
		rBracket, /// ']'
		lBrace, /// '{'
		rBrace, /// '}'
		lParent, /// '('
		rParent /// ')'
	}

	static immutable SpecialStr = [ "", "EOF", "dot '.'", "semicolon ';'", "':'", "'@'", "'['", "']'", "'{'", "'}'", "'('", "')'" ];

public:
	this( Special special ) {
		this( );
		type = Type.special;
		data.special = special;
	}

	this( Identifier identifier ) {
		this( );
		type = Type.identifier;
		data.identifier = identifier;
	}

	this( Keyword keyword ) {
		this( );
		type = Type.keyword;
		data.keyword = keyword;
	}

	this( Operator operator ) {
		this( );
		type = Type.operator;
		data.operator = operator;
	}

public:
	CodeLocation codeLocation;
	const Type type;

public:
	@property {
		Identifier identifier( ) {
			assert( type == Type.identifier );
			return data.identifier;
		}

		Keyword keyword( ) {
			assert( type == Type.keyword );
			return data.keyword;
		}

		Operator operator( ) {
			assert( type == Type.operator );
			return data.operator;
		}

		Special special( ) {
			assert( type == Type.special );
			return data.special;
		}
	}

public:
	void expect( Type type, lazy string whatExpected = null ) {
		expect( type, typeDefaultData[ type ], whatExpected );
	}

	void expect( Keyword kwd, lazy string whatExpected = null ) {
		Data data = {keyword:
		kwd};
		expect( Type.keyword, data, whatExpected );
	}

	void expect( Operator op, lazy string whatExpected = null ) {
		Data data = {operator:
		op};
		expect( Type.operator, data, whatExpected );
	}

	void expect( Special sp, lazy string whatExpected = null ) {
		Data data = {special:
		sp};
		expect( Type.special, data, whatExpected );
	}

	void expect( Type type, const Data data, lazy string whatExpected = null ) {
		if ( this.type != type ) {
			string we = whatExpected;
			berror( E.unexpectedToken, "Expected " ~ ( we ? we : descStr( type, data ) ) ~ " but got " ~this.descStr, codeLocation.errGuardFunction );
		}

		bool result;

		switch ( type ) {

		case Type.keyword:
			result = data.keyword == Keyword._noKeyword || this.data.keyword == data.keyword;
			break;

		case Type.operator:
			result = data.operator == Operator._noOperator || this.data.operator == data.operator;
			break;

		case Type.special:
			result = data.special == Special._noSpecial || this.data.special == data.special;
			break;

		default:
			result = true;
			break;

		}

		if ( !result )
			reportUnexpectedToken( "Expected " ~ ( whatExpected ? whatExpected : descStr( type, data ) ) ~ " but got " ~ descStr );
	}

	void reportUnexpectedToken( string message ) {
		berror( E.unexpectedToken, message, codeLocation.errGuardFunction );
	}

public:
	bool opEquals( Type t ) const {
		return type == t;
	}

	bool opEquals( Keyword kwd ) const {
		return type == Type.keyword && data.keyword == kwd;
	}

	bool opEquals( Operator op ) const {
		return type == Type.operator && data.operator == op;
	}

	bool opEquals( Special spec ) const {
		return type == Type.special && data.special == spec;
	}

private:
	this( ) {
		assert( lexer );
		codeLocation.source = lexer.source;
		codeLocation.startPos = lexer.tokenStartPos;
		codeLocation.length = lexer.pos - lexer.tokenStartPos;
		type = Type._noToken;
	}

public:
	string descStr( ) {
		return descStr( type, data );
	}

	static string descStr( Type type, const Data data ) {
		string result = typeStr[ type ];

		switch ( type ) {

		case Type.identifier: {
				if ( data.identifier )
					result ~= " '" ~ data.identifier.str ~ "'";
			}
			break;

		case Type.keyword: {
				if ( data.keyword != Keyword._noKeyword )
					result ~= " '" ~ keywordStr[ cast( size_t ) data.keyword ] ~ "'";
			}
			break;

		case Type.operator: {
				string str = operatorStr[ cast( int ) data.operator ];
				if ( str )
					result ~= " '" ~ str ~ "'";
			}
			break;

		case Type.special: {
				result ~= SpecialStr[ cast( int ) data.operator ];
			}
			break;

		default:
			break;

		}

		return result;
	}

private:
	union Data {
		Identifier identifier;
		Keyword keyword;
		Operator operator;
		Special special;
	}

	Data data;

}
