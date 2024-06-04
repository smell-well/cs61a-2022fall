## hw01

说实话，没想到第一个就难住了。
这种函数式的思想在这门课中挺常见的，也是提醒自己要把函数也理解成一个变量。

```python
def a_plus_abs_b(a, b):
    """Return a+abs(b), but without calling abs.
    >>> a_plus_abs_b(2, 3)
    5

    >>> a_plus_abs_b(2, -3)
    5

    >>> a_plus_abs_b(-1, 4)
    3

    >>> a_plus_abs_b(-1, -4)
    3
    """
    if b < 0:
        f = sub
    else:
        f = add
    return f(a, b)
```

## hw02

通关

注意一下后两个函数，要删除`"***YOUR CODE HERE***"`
```python
def summation_using_accumulate(n, term):
    """Returns the sum: term(0) + ... + term(n), using accumulate.

    >>> summation_using_accumulate(5, square)
    55
    >>> summation_using_accumulate(5, triple)
    45
    >>> # You aren't expected to understand the code of this test.
    >>> # Check that the bodies of the functions are just return statements.
    >>> # If this errors, make sure you have removed the "***YOUR CODE HERE***".
    >>> import inspect, ast
    >>> [type(x).__name__ for x in ast.parse(inspect.getsource(summation_using_accumulate)).body[0].body]
    ['Expr', 'Return']
    """
    return accumulate(add, 0, n, term)
```

## hw03

### Num eights

注意，python中的三目运算还是用括号括起来会比较好，不然容易出现解析错误的问题。

```python
def num_eights(pos):
    """Returns the number of times 8 appears as a digit of pos.
    """
    "*** YOUR CODE HERE ***"
    if pos == 0:
        return 0
    # print("DEBUG: " + str(pos))
    return num_eights(pos // 10) + (1 if (pos % 10) == 8 else 0)
```

### Busy Beaver Contest

在这题中，由于不能用数字指定次数和不能死循环，所以还是挺麻烦。下面的写法是参考的，思想借鉴了 [[Lab_Record#lab03#Church numerals| lab03 Church Numerals]]  中构建幂次的思想，这段代码可以让f执行`pow(3, 7) = 2187` 次

```python
def beaver(f):
    "*** YOUR CODE HERE ***"
    # first category
    return (lambda g: g(g(g(g(g(g(g(f))))))))(lambda f: lambda: f() or f() or f())()
```


## hw04

这次作业主要强化树与数据抽象，做的还是比较顺的。

### Q8: Interval Arithmetic

要把错误的代码改的规范。这里一开始忘记了返回类型也需要封装，找了老半天。

```python
def mul_interval(x, y):
    """Return the interval that contains the product of any value in x and any
    value in y."""
    # print("DEBUG: ", lower_bound(x), upper_bound(x))
    # print("DEBUG: ", lower_bound(y), upper_bound(y))
    p1 = lower_bound(x) * lower_bound(y)
    p2 = lower_bound(x) * upper_bound(y)
    p3 = upper_bound(x) * lower_bound(y)
    p4 = upper_bound(x) * upper_bound(y)
    return interval(min(p1, p2, p3, p4), max(p1, p2, p3, p4))
```

## hw05

这章作业是我感觉比较有难度的一章，可能是因为前面的内容确实比较熟悉，generator确实接触比较少，学习起来有点梯度。经过Q1与Q2的卡题其实后续理解起来还是比较快的。


generator我理解成一类特殊的迭代器，它是一个函数，我们可以用`yield`控制函数的弹出答案的位置，从而控制 generator 生成的内容。注意`yield` 与 `return`是有区别的，`yield`**是有状态的**，下一个生成的**会从上次`yield`出去的地方继续**，因此使用 `next(generator)`与再次调用一个函数有区别，这里要细细区分。

### Q1: Merge

这题卡我了很久，应该是没有正确理解 generator 的问题，其实思路是简单的，有点类似与归并排序的做法，但是因为觉得每次next之后的值就浪费了，没有意识到`yield`**其实是可以保存变量状态的，所以我们还是可以用一个变量存下来**，解决的思路其实和归并排序的代码就没什么区别了

```python
def merge(a, b):
    """
    >>> def sequence(start, step):
    ...     while True:
    ...         yield start
    ...         start += step
    >>> a = sequence(2, 3) # 2, 5, 8, 11, 14, ...
    >>> b = sequence(3, 2) # 3, 5, 7, 9, 11, 13, 15, ...
    >>> result = merge(a, b) # 2, 3, 5, 7, 8, 9, 11, 13, 14, 15
    >>> [next(result) for _ in range(10)]
    [2, 3, 5, 7, 8, 9, 11, 13, 14, 15]
    """
    "*** YOUR CODE HERE ***"
    first_a, first_b = next(a), next(b)
    while True:
        if first_a == first_b:
            yield first_b
            first_a, first_b = next(a), next(b)
        elif first_a < first_b:
            yield first_a
            first_a = next(a)
        else:
            yield first_b
            first_b = next(b)
```

### Q2: Generate Permutations

这一问主要学习`yield from` 和 `yield` 的配合使用，确实有点复杂。
一句话总结，**python判断generator是短视的，判断不了嵌套函数的yield，嵌套的函数要用`yield from`来迭代嵌套函数**。

先来看一下写的错误代码。我的本意是希望每次都执行到dfs中的递归结束阶段yield出返回值，但是实际上执行过程并不如我想的这样。

首先，因为note2的写法，python不会把函数看成是一个generator函数。如果改成`yield dfs(...)` 也是不对的，因为yield只能弹出一次，而dfs显然是一个多次返回的过程，所以需要使用 `yield from dfs(...)` 这样才可以迭代出dfs里的内容。

第二个，注意note1。其实问题是类似的，在进入else 分支后，这个分支下没有yield的返回内容，即使dfs有递归，那也是下一个递归函数里才能返回的了，所以也需要用`yield from` 来联系这两个函数。

```python
def gen_perms(seq):
    def dfs(seq, vis, lst):
        if len(lst) == len(seq):
            # print("DEBUG:", lst)
            yield list(lst)
        else:
            for i in range(len(vis)):
                if not vis[i]:
                    lst.append(seq[i])
                    vis[i] = True
                    # note1 注意这里
                    dfs(seq, vis, lst)
                    lst.pop(len(lst) - 1)
                    vis[i] = False
    vis = [False for _ in seq]
    # note2 注意这里
    dfs(seq, vis, [])

```

正确的写法如下。
```python
def gen_perms(seq):
    def dfs(seq, vis, lst):
        if len(lst) == len(seq):
            # print("DEBUG:", lst)
            yield list(lst)
        else:
            for i in range(len(vis)):
                if not vis[i]:
                    lst.append(seq[i])
                    vis[i] = True
                    yield from dfs(seq, vis, lst)
                    lst.pop(len(lst) - 1)
                    vis[i] = False
    vis = [False for _ in seq]
    yield from dfs(seq, vis, [])
```

## hw06

### Q4: Two List

这个主要是一个递归链表的过程，但是用类进行了封装。主要是用了一下哑节点，方便处理。

```python
def two_list(vals, counts):
    """
    Returns a linked list according to the two lists that were passed in. Assume
    vals and counts are the same size. Elements in vals represent the value, and the
    corresponding element in counts represents the number of this value desired in the
    final linked list. Assume all elements in counts are greater than 0. Assume both
    lists have at least one element.

    >>> a = [1, 3, 2]
    >>> b = [1, 1, 1]
    >>> c = two_list(a, b)
    >>> c
    Link(1, Link(3, Link(2)))
    >>> a = [1, 3, 2]
    >>> b = [2, 2, 1]
    >>> c = two_list(a, b)
    >>> c
    Link(1, Link(1, Link(3, Link(3, Link(2)))))
    """
    "*** YOUR CODE HERE ***"
    dummy_head = Link(-1)
    ptr = dummy_head
    for val, count in zip(vals, counts):
        for _ in range(count):
            ptr.rest = Link(val, ptr.rest)
            ptr = ptr.rest
    return dummy_head.rest
```

### Q6: Is BST

这题需要判断平衡二叉树，麻烦在于没有指定左右分支，所以需要对仅有一个分支的情况进行额外的判断。根据提示先写了两个helper函数，然后分别对分支数为 0，1，else三种情况的满足条件进行了判断。

```python
def is_bst(t):
    def bst_min(t):
        sz = len(t.branches)
        if sz == 0:
            return t.label
        else:
            return min(t.label, bst_min(t.branches[0]))

    def bst_max(t):
        sz = len(t.branches)
        if sz == 0:
            return t.label
        else:
            return max(t.label, bst_max(t.branches[-1]))

    if len(t.branches) == 0:
        return True
    elif len(t.branches) == 1:
        return is_bst(t.branches[0]) and \
            (t.label >= bst_max(t.branches[0]) or t.label < bst_min(t.branches[0]))

    left, left_max = is_bst(t.branches[0]), bst_max(t.branches[0])
    right, right_min = is_bst(t.branches[-1]), bst_min(t.branches[-1])

    return left and right and left_max <= t.label < right_min
```


## hw07

超级大菜，看文档给就我看了一个小时。我自己的学习过程是看了一点[cs61a-scheme视频](https://www.bilibili.com/video/BV1s3411G7yM?p=62&vd_source=339d8ea7c2b766d55b0806362a10b619)，然后也通读了一下 [Scheme Specification](https://inst.eecs.berkeley.edu/~cs61a/fa22/articles/scheme-spec/#pairs-and-lists)这样对Scheme有个大概的认识，然后直接做课程的题目，遇到不懂的再查。

这一节因为要频繁的实验，可以运行`python editor`在编辑器页面写，而且也可以运行测试，很方便。

### Q1: Thane of Cadr

实现第2和第3个元素的获取。首先 scheme中的list/pair **类似于之前做的 link的结构**，car 可以获取link.first，cdr则获取link.rest，而link.rest 实际上就是又一个list/pair。

```scheme
(define (cadr s) (car (cdr s)))

(define (caddr s) (car (cddr s)))
```


### Q2: Ascending

还是应该多看代码啊，看了老师课堂视频上写的一下就有感觉了。

怎么返回true？？刚开始写 (#t) 一直返回是错误的，**scheme括号不能乱用！**，() 表示将里面的内容看成call expression，所以处理不来 布尔值了，对于函数的调用上也是同理，必须是cadr list，不能是cadr (list)

```scheme
(define (ascending? asc-lst) (if (> (length asc-lst) 1) 
                                 (if (<= (car asc-lst) (cadr asc-lst)) 
                                     (ascending? (cdr asc-lst))
                                     #f) 
                                 #t))
```


### Q3: Pow

好像是要用快速幂实现啊，这么变态吗

哈哈，写得熟悉起来了。这里额外加了一个base 为1的判断，因为有一个测试用例是的指数太大了，所以直接特判了。

```scheme
(define (pow base exp) (cond ((= exp 0) 1)
                             ((= exp 1) base)
                             ((= base 1) 1)
                             (else (if (even? exp)
                                       (* (pow base (/ exp 2)) (pow base (/ exp 2)))
                                       (* (pow base (/ (+ exp 1) 2)) (pow base (/ (- exp 1) 2)))))))

```

## hw08

### Q2: Interleave

时刻要注意括号啊，**返回的是生成list的子程序的话要用 括号 才会执行**。

```scheme
(define (interleave lst1 lst2) (cond ((and (null? lst1) (null? lst2)) nil)
                                     ((null? lst1) lst2)
                                     ((null? lst2) lst1)
                                     (else (cons (car lst1) (cons (car lst2) (interleave (cdr lst1) (cdr lst2)))))))
```

### Q4: No Repeats

刚开始想复杂了，以为要用一个可以迭代变深的lambda函数存下每个出现过的数字，但是实际上不用这么麻烦，**只要每次都过滤一遍，得到新的list就行**。

```scheme
(define (no-repeats lst) (if (null? lst)
                             nil
                             (cons (car lst)
                               (no-repeats (my-filter 
                                                      (lambda (x) 
                                                              (not (= x (car lst))))
                                                      (cdr lst))))))
```

## hw09

### Q2: When Macro

 scheme实在是太博大精深了，摸索出了通过字符串拼接来写宏的方法，但是对于怎么用begin处理 (() ()) 这样的表达式而卡住了。实际上解决方法也简单，只要用cons 连接两个元素就行了。说到底还是对cons的理解不够深刻。

cons可以做到`(cons 1 '(1 2 3) -> (1 1 2 3)`

```scheme
(define-macro (when condition exprs)
    (list 'if condition
          (cons 'begin exprs)
          ''okay
    )
)
```

### Q3: Switch

首先是要明白switch想让我们干什么，其实是要写一个类似于cond的程序，但是我刚开始的方法是在map里写一个if程序，感觉应该也是可行的。

即使有了方案但还是很难实现。其实是因为我们漏了一个内容，就是关于反引号与逗号的部分，可以看官网里的youtube视频。反引号与逗号可以让我们使用字符串拼接起来更加的灵活，实现课程里所说的，代码即数据，code is data。

```scheme
(define-macro (switch expr cases)
	(cons 'cond
		(map (lambda (case) (cons `(equal? ,expr ',(car case)) (cdr case)))
    			cases))
)
```

## hw10

### Q4: Low Variance

首先分析一下题目，有几个关键点：
- 按毛来分类
- 所有的狗的身高要在平均值的0.7-1.3之间
- 分类中有不满足第二点的狗的也不在输出中

我自己在做的时候是通过子查询的方式来做的，因为不知道怎么排除存在不满足身高的组的分类。代码如下

```sql
CREATE TABLE low_variance AS
  SELECT dogs.fur, MAX(height) - MIN(height)
  FROM dogs, (
    SELECT fur, COUNT(name) AS cnt
    FROM dogs
    GROUP BY fur
    HAVING height >= 0.7 * AVG(height) and height <= 1.3 * AVG(height)
  ) AS t
  GROUP BY dogs.fur
  HAVING COUNT(height) = t.cnt AND t.fur = dogs.fur;
```

这样做就是复杂了很多，而且使用了join，相比于如下官方解答的效率不高。

```sql
// 官方解答
CREATE TABLE low_variance AS
  SELECT fur, MAX(height) - MIN(height) FROM dogs GROUP BY fur
      HAVING MIN(height) >= .7 * AVG(height) AND MAX(height) <= 1.3 * AVG(height);
```