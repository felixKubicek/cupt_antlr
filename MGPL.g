// Robert Schäfer
// Felix Kubicek

grammar MGPL;

options
{
  backtrack = false;
  k = 1;
// output = AST;
}

// parser rules
prog	:	'game' IDF attrAssListBegin decl* stmtBlock block*EOF; 

decl	:	varDecl ';' | objDecl ';';
varDecl	:	'int' IDF varDecl_alt;
varDecl_alt
	:	init? | '[' NUMBER ']';
init	:	'=' expr;
objDecl	:	objType IDF objDeclCont;
objDeclCont
	:	 attrAssListBegin |  '[' NUMBER ']' ;
objType	:	'rectangle' | 'triangle' | 'circle';

attrAssListBegin
	:	'(' attrAssList;

attrAssList
	:	 ')' |  assStmt assStmtCont;
assStmtCont
	:	 ',' assStmt assStmtCont | ')';



block	:	animBlock | eventBlock;
animBlock
	:	'animation' IDF '(' objType IDF ')' stmtBlock;
eventBlock
	:	'on' keyStroke stmtBlock;
keyStroke
	:	'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow';
stmtBlock
	:	'{' stmt* '}';
stmt	:	ifStmt | forStmt | assStmt ';'; 
ifStmt	:	'if' '(' expr ')' stmtBlock ('else' stmtBlock)?;
forStmt	:	'for' '(' assStmt ';' expr ';' assStmt ')' stmtBlock;
assStmt	:	var '=' expr;
var	:	IDF var_alt;
var_alt :	DOT IDF | LBRACK expr RBRACK var_array_alt|;
var_array_alt
	:	DOT IDF | ;

expr	:	orExpr ;
orExpr	:	andExpr (OR andExpr)*;
andExpr	:	relExpr (AND relExpr)*;
relExpr	:	addExpr (relOp addExpr)*;
relOp 	:	EQ | SEQ | ST;
addExpr	:	multExpr (addOp multExpr)*;
addOp	:	PLUS | MINUS;
multExpr:	uExpr (multOp uExpr)*;
multOp	:	TIMES | DIV;
uExpr	:	uOp (NUMBER | var ('touches'^ var)? | '(' expr ')');
uOp	:	MINUS | NOT |;


// scanner rules
// operators ordered by precedence


DOT	:	'.';

LBRACK	:	'[';
RBRACK	:	']';

OR	:	'||';

AND	:	'&&';

EQ	:	'==';
SEQ	:	'<=';
ST	:	'<';

PLUS	:	'+';
MINUS	:	'-';

TIMES	:	'*';
DIV	:	'/';

NOT	:	'!';
NUMBER	:	('0' |('1'..'9') ('0'..'9')*);
// Whitespace -- ignored
WS 	: 	(' '|'\r'|'\t'|'\u000C'|'\n') { $channel=HIDDEN; };
// Single line comments -- ignored
COMMENT	: 	'//' ~( '\r' | '\n' )* { $channel=HIDDEN; };

IDF	:	(('a'..'z' | 'A'..'Z')('a'..'z' | 'A'..'Z' |'0'..'9' | '_')*);




