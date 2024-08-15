;int main() 
FUNC @main:
	var i
	push 0
	pop i
	_beg_while:
		push i
		push 10
		cmplt
		jz _end_while
		push i
		push 1
		add
		pop i
		_beg_if1:
			push i
			push 3
			cmpeq
			push i
			push 5
			cmpeq
			or
		jz _end_if1
			jmp _beg_while
		_end_if1:
		_beg_if2:
			push i
			push 8
			cmpeq
			jz _end_if2
			jmp _end_while
		_end_if2:
		push i
		push i
		$factor
		print "%d! = %d"
	jmp _beg_while
	_end_while:
	ret 0
ENDFUNC

FUNC @factor:
	arg n
	_beg_if:
		push n
		push 2
		cmplt
		jz _end_if
		ret 1
	_end_if:
	; return n * factor(n - 1);
	push n
	push n
	push 1
	sub
	$factor
	mul
	ret ~
ENDFUNC