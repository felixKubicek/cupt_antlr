grammar MGPL;

// k = 1;
// output = AST;
options
{
  backtrack = true;
}

// parser rules
prog	:	'game' IDF '(' attrAssList? ')' decl* stmtBlock block*EOF; 

decl	:	varDecl ';' | objDecl ';';
varDecl	:	'int' IDF init? | 'int' IDF '[' NUMBER ']';
init	:	'=' expr;
objDecl	:	objType IDF '(' attrAssList? ')' |  objType IDF '[' NUMBER ']' ;
objType	:	'rectangle' | 'triangle' | 'circle';
attrAssList 
	:	attrAss (',' attrAss)*;
attrAss	:	assStmt;
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
var	:	IDF | IDF DOT IDF | arrayVar;
arrayVar:	IDF LBRACK expr RBRACK DOT IDF | IDF LBRACK expr RBRACK;

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




