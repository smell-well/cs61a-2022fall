## Part 1

### Problem 3 (2 pt)

这题要实现表达式的计算，这是一个递归的过程。需要**实现的其实是操作符与操作数都是表达式的情形**。first的处理比较简单，可以直接用scheme_eval完成，但是对于操作数的部分，需要使用Pair.map，但是map又只能接受一个函数名，所以我们**需要定义一个helper函数**。

```python
def scheme_eval(expr, env, _=None):  # Optional third argument is ignored
    """Evaluate Scheme expression EXPR in Frame ENV.

    >>> expr = read_line('(+ 2 2)')
    >>> expr
    Pair('+', Pair(2, Pair(2, nil)))
    >>> scheme_eval(expr, create_global_frame())
    4
    """
    # Evaluate atoms
    if scheme_symbolp(expr):
        return env.lookup(expr)
    elif self_evaluating(expr):
        return expr

    # All non-atomic expressions are lists (combinations)
    if not scheme_listp(expr):
        raise SchemeError('malformed list: {0}'.format(repl_str(expr)))
    first, rest = expr.first, expr.rest
    if scheme_symbolp(first) and first in scheme_forms.SPECIAL_FORMS:
        return scheme_forms.SPECIAL_FORMS[first](rest, env)
    else:
        # BEGIN PROBLEM 3
        "*** YOUR CODE HERE ***"
        def helper(expr):
            return scheme_eval(expr, env)
        operator = scheme_eval(first, env)
        operands = rest.map(helper)
        return scheme_apply(operator, operands, env)
        # END PROBLEM 3
```

### Problem 4 (2 pt)

注意define 表达式只接受长度为2的Pair，所以**expr.rest实际上是一个嵌套的完整Pair**而不是一个参数，所以要用expr.rest.first

```scheme
def do_define_form(expressions, env):
    validate_form(expressions, 2)  # Checks that expressions is a list of length at least 2
    signature = expressions.first
    if scheme_symbolp(signature):
        # assigning a name to a value e.g. (define x (+ 1 2))
        validate_form(expressions, 2, 2)  # Checks that expressions is a list of length exactly 2
        # BEGIN PROBLEM 4
        "*** YOUR CODE HERE ***"
        # print("DEBUG: expressions.rest", expressions.rest)
        # print("DEBUG: expressions.rest", expressions.rest.first)
        value = scheme_eval(expressions.rest.first, env)
        # print("DEBUG:", value)
        env.define(signature, value)
        return signature
        # END PROBLEM 4

scm> (define x (+ 2 3))
DEBUG: expressions.rest ((+ 2 3))
DEBUG: expressions.rest (+ 2 3)
```

## Part 3
### Problem 14 (2 pt)

与[[scheme_record#Problem 4 (2 pt)]] 的问题类似，**不能直接传一个包含数值的Pair**给scheme_eval，而是要用expr.first

```python
def make_let_frame(bindings, env):
    if not scheme_listp(bindings):
        raise SchemeError('bad bindings list in let form')
    names = vals = nil
    # BEGIN PROBLEM 14
    "*** YOUR CODE HERE ***"
    binding = bindings
    # print("DEBUG: bindings", bindings)
    while binding != nil:
        validate_form(binding.first, 2, 2)
        names = Pair(binding.first.first, names)
        # print("DEBUG: val", binding.first.rest)
        # 重点注意！！！
        vals = Pair(scheme_eval(binding.first.rest.first, env), vals)
        binding = binding.rest
    validate_formals(names)
    # END PROBLEM 14
    return env.make_child_frame(names, vals)
```

## Part 4
### Problem 15 (2 pt)

思路比较好想，但是代码问题debug了好久。define里可以写body，注意要把**helper的定义与执行在第一个define的body里执行**！！

```scheme
(define (enumerate s)
  ; BEGIN PROBLEM 15
  (define (helper x)
    (if (null? x) 
        () 
        (append (cons(cons (- (length s) (length x)) (cons (car x) nil)) nil) 
                (helper (cdr x)))))
    (helper s)
  )
```

## EC
### Problem EC (1 pt)

直接做的话可能看不懂，可以先看[视频](https://www.bilibili.com/video/BV1GK411Q7qp?p=42&vd_source=339d8ea7c2b766d55b0806362a10b619)
尾递归实际上的作用是，当我们从递归的深处返回ret值时，有些情况下是直接往上抛ret就可以，所以这些函数的帧就可以省略了，空间上效率更高。

要修改已有的function内容有eval_all， do_and_form与do_or_form，do_if_form

以下是一些可以使用尾递归的场景
![[tail_calls.png]]

## Optional
### Optional Problem 1 (0 pt)

首先要明白scheme是怎么处理引号的，经过以下测试，可以看到输入处理会把引号用quote 关键字处理了。

```scheme
scm> (car '(1 2 3))
DEBUG: expr= (car (quote (1 2 3)))
DEBUG: expr= (quote (1 2 3))
1
```

define-macro与define肯定是很相似的，但是两者之间执行的过程有区别。我们以定义函数为例子。
以define定义函数，一般过程如下：
1、创建LambdaProcedure，存下formals与body
2、当函数调用时，将入参与formals绑定创建子frame
3、执行函数body

而define-macro的过程则是：
1、创建MacroProcedure，存下formals与body
2、当函数调用时，将入参与formals绑定创建子frame
**3、解析body，但是不进行eval，只是把formals中的内容用入参替换**
4、执行解析后的body

因此define-macro的关键就在于怎么实现参数的替换，但是又不真正执行eval的过程的添加。回想两个主要的函数 scheme_apply 与 scheme_eval。
- scheme_eval 负责执行，将表达式的值计算出来
- scheme_apply 将参数值应用到proceduce中

所以，我们需要先用scheme_apply处理define-macro中的body，然后才是真正的执行，计算表达式的值。**总结下来就是，正常的流程是call expr里计算每一个表达式，而define-macro先将参数值应用了，然后再计算每一个call expr**

因此，代码如下
```python
def scheme_eval(expr, env, tail=None):  # Optional third argument is ignored
    # Evaluate atoms
    if scheme_symbolp(expr):
        return env.lookup(expr)
    elif self_evaluating(expr):
        return expr
    
    # All non-atomic expressions are lists (combinations)
    if not scheme_listp(expr):
        raise SchemeError('malformed list: {0}'.format(repl_str(expr)))
    first, rest = expr.first, expr.rest
    if scheme_symbolp(first) and first in scheme_forms.SPECIAL_FORMS:
        return scheme_forms.SPECIAL_FORMS[first](rest, env)
    else:
        # BEGIN PROBLEM 3
        # print("DEBUG: expr=", expr)
        "*** YOUR CODE HERE ***"
        def helper(expr):
            return scheme_eval(expr, env)
        operator = scheme_eval(first, env)
        if isinstance(operator, MacroProcedure):
            eval_body = scheme_apply(operator, rest, env)
            # 用于使用尾递归的情况
            # return scheme_eval(complete_apply(operator, rest, env), env, True)
            return scheme_eval(eval_body, env)
        else:
            operands = rest.map(helper)

        return scheme_apply(operator, operands, env)
```

### Optional Problem 2 (0 pt)

最难的一集！！！
好好好，选做题搞这么难是吧。还不给分！感觉题目给的let-to-lambda的例子还是太少了，直接看test的例子去理解会好一些。

**~~重要！这个函数的输出其实是一个str！而不是真的要执行的结果！~~**
**输出的一个表达式，不是具体的执行结果！**

做完以后：感觉这一题比上面一个Part部分花的时间都多。所以做不出来是正常的，参考其他人的代码也未尝不可。
#### zip函数

这个zip函数也是好恶心啊，要强行改变思维的方式，要用函数式的思维来想问题，好难卧槽。我的做法是写两个子函数，每个子函数负责从一个pair中选第一个元素，另一个选第二个。

首先要说明一个区别，如下所示，cdar返回实际上是一个list，而不是一个值，这点还是挺困扰我的。

```scheme
scm> (zip '((1 2) (3 4) (5 6)))
((1 3 5) (2 4 6))
scm> (print (caar ((1 2))))
1
scm> (print (cdar ((1 2))))
(2)
```

#### 主函数

先说最麻烦的let部分的处理，首先需要用zip将 let 中定义变量的部分取出分成两个pair，然后我们要构造相应的lambda表达式。但是直接用`(lambda (car (zip values)) (car body)) (car (cadr (zip values)))` 这样是不行的，(car (zip values))，而我们**这个做法实际上隐含了一种先后关系**，即先计算出 `(car (zip values))` 这样的内容然后再组成表达式。因此，我们需要人为的构造出这种计算上的先后。**可以使用 quote 命令，它会字面处理而不是真的执行**，所以可以达到先计算出值的效果。

然后比较麻烦的是 lambda 或者 define 的部分。实际上就是对原来表达式进行一个重组，注意body里面可能有需要递归处理的内容（比如里面有let）。

剩下的判断分支其实比较简单了，但是实际的实现细节比我这里说的要多，不过可以通过不断地用测试用例进行改进。最后4个用例都通过了是非常激动地哈哈。

```scheme
(define (let-to-lambda expr)
  (cond 
    ((atom? expr)
     ; BEGIN OPTIONAL PROBLEM 2
     expr
     ; END OPTIONAL PROBLEM 2
    )
    ((quoted? expr)
     ; BEGIN OPTIONAL PROBLEM 2
     expr
     ; END OPTIONAL PROBLEM 2
    )
    ((or (lambda? expr) (define? expr))
     (let ((form (car expr))
           (params (cadr expr))
           (body (cddr expr)))
       ; BEGIN OPTIONAL PROBLEM 2
    ;   (if (equal? form 'lambda)
    ;       (lambda params body)
    ;       (define ((car params) (cdr params)) body))
        ; (print body)
        (cons form (cons params (let-to-lambda body)))
       ; END OPTIONAL PROBLEM 2
     ))
    ((let? expr)
     (let ((values (cadr expr))
           (body (cddr expr)))
       ; BEGIN OPTIONAL PROBLEM 2
       (
            ; (print (car body))
        ;   (lambda (eval ) (car body)) (car (cadr (zip values)))
           cons (cons 'lambda (cons (car (zip values)) (cons (let-to-lambda (car body)) nil))) (let-to-lambda (cadr (zip values)))
        )
       ; END OPTIONAL PROBLEM 2
     ))
    (else
     ; BEGIN OPTIONAL PROBLEM 2
     (map let-to-lambda expr)
     ; END OPTIONAL PROBLEM 2
    )))

; Some utility functions that you may find useful to implement for let-to-lambda
; scm> (zip '((1 2) (3 4) (5 6)))
; ((1 3 5) (2 4 6))
(define (zip pairs)
  ;   (print pairs)
  (define (getFirst lst)
    (if (null? lst)
        nil
        (cons (caar lst) (getFirst (cdr lst)))))
  (define (getRest lst)
    (if (null? lst)
        nil
        ; (print (car (cdar lst)))))
        (cons (car (cdar lst)) (getRest (cdr lst)))))
  (cons (getFirst pairs) (cons (getRest pairs) nil)))

```
