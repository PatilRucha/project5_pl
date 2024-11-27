%%%%%%%%%%%%%%%%%
% Parsing code:
%%%%%%%%%%%%%%%%%

% Main parser predicate
parse(X) :-
    phrase(lines, X).

% Grammar rules

% Num → Digit | Digit Num
num --> digit.
num --> digit, num.

% Line → Num ,Line | Num
line --> num, [','], line.
line --> num.

% Lines → Line ; Lines | Line
lines --> line, [';'], lines.
lines --> line.

% Digit → 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
digit --> ['0'].
digit --> ['1'].
digit --> ['2'].
digit --> ['3'].
digit --> ['4'].
digit --> ['5'].
digit --> ['6'].
digit --> ['7'].
digit --> ['8'].
digit --> ['9'].

% Example execution:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.
