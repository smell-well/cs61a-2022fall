## lab00

**过关！**
```shell
$ python ok --submit
=====================================================================
Assignment: Lab 0
OK, version v1.18.1
=====================================================================

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Running tests

---------------------------------------------------------------------
Test summary
    3 test cases passed! No cases failed.
```

### 总结

lab00还是偏入门的，主要是配置环境，复习下python的基础知识。


## lab01

**过关**
```shell
Running tests

---------------------------------------------------------------------
Test summary
    18 test cases passed! No cases failed.
```



### WWPD

这题还是有点意思的，因为每次只会-3，所以positive总是非0，无限循环。

```python
>>> positive = 28
>>> while positive: # If this loops forever, just type Infinite Loop
...    print("positive?")
...    positive -= 3
(line 1)? positive?
-- Not quite. Try again! --
```

这个是我没想到的，没想到python的断路原则居然是这样。等价于每次都输出最后一个表达式的值

>If `and` and `or` do not _short-circuit_, they just return the last value;

```python
>>> True and 13
? 13
-- OK! --

# 还有这个更容易错的
>>> 0 or False or 2 or 1 / 0  # If this errors, just type Error.
? Error
-- Not quite. Try again! --
# answer is 2
```

### Writing

这个都比较简单，逻辑清晰即可






## lab02

### HOF Diagram Practice

感觉这段代码还是比较绕的。要明确两点：
- **在函数调用时，会创建一个新的栈帧，保存输入和一些状态
- **执行过程是，从左至右的。

>附可视化链接：[Online Python Tutor](https://pythontutor.com/cp/composingprograms.html#mode=display)

```python
n = 7

def f(x):
    n = 8
    return x + 1

def g(x):
    n = 9
    def h():
        return x + 1
    return h

def f(f, x):
    return f(x + n)

f = f(g, n)
g = (lambda y: y())(f)
```

### I Heard You Liked Functions...

这题需要实现的函数比较复杂，且需要写成高阶函数形式。我们可以先想象一个全局的fun，它的入参一共有，`f1, f2, f3, n, x`，这个函数的逻辑是
```python
def fun(f1, f2, f3, n, x):
	res = x
	for i in range(0, n):
		if i % 3 == 0:
			res = f1(res)
		elif: i % 3 == 1:
			res = f2(res)
		else:
			res = f3(res)
	return res
```
所以，我们只需要将上面这个函数柯里化（curring）即可。
这题一开始卡住了，是无法解决函数内**嵌套函数使用外部变量的问题，如果出现写操作，会把该变量视为本地变量**，读才可以作为外部变量读。



## lab03

### K Runner

这题有个特殊情况是，要判断 n 只剩下1位时，需要及时停止，不能除到0
```python
def get_k_run_starter(n, k):
    """Returns the 0th digit of the kth increasing run within n.
    """
    i = 0
    final = None
    while i <= k:
        while n % 10 > ((n // 10) % 10) and n >= 10:
            n //= 10
        final = n % 10
        i = i + 1
        n = n // 10
    return final
```


### It's Always a Good Prime
首先是明确一下提议，对于n，x，判断x是不是可以被 [2, n] 中任意的一个数整除，也就是，x可以被[2, n]中的质数整除。

这题感觉是比较有难度的，尤其是给定了代码的结构，会显得更难想一点。
首先是要根据代码结构猜测函数的逻辑，结合题目给出的hint
>`checker = (lambda f, i: lambda x: __________)(checker, i)`

大致可以判断，checker就是我们最终返回的函数，然后从lambda传入了一个函数可以猜测，可能是构建一个**类似递归的函数，而 i 就代表着质数，判断是否能被 i 整除**。顺着这个思路，我们可以写出lambda表达式下的函数内容。

另外补充一点，这题中找质数的方法优点类似于筛法，一个数只会被比它小的质数整除，所以当`if not checker(i):` 这句话**实际就可以说明 i 是一个质数了**。

```python
def div_by_primes_under(n):
    checker = lambda x: False
    i = 2
    while i <= n:
        if not checker(i):
            checker = (lambda f, i: lambda x: x % i == 0 or f(x))(checker, i)
        i = i + 1
    return checker

def div_by_primes_under_no_lambda(n):
    def checker(x):
        return False
    i = 2
    while i <= n:
        if not checker(i):
            def outer(func, i):
                def inner(x):
                    return func(x) or x % i == 0
                return inner
            checker = outer(checker, i)
        i = i + 1
    return checker
```



### Church numerals

这一系列题目还是挺考验思维的。对于church num，在我的理解中，它把一个数字分解成了三部分。
- n： 需要重复 f 的次数
- f：表示数与数的关系
- x：起始值

分析清楚这三部分的内容后，其实add、mul、pow就是对这三部分内容的组合，通过使用不同的输入 f 与 x 完成不一样的效果。
```python
def add_church(m, n):
    """Return the Church numeral for m + n, for Church numerals m and n.

    >>> church_to_int(add_church(two, three))
    5
    """
    "*** YOUR CODE HERE ***"
    def add(f):
        return lambda x:  n(f)(m(f)(x))
    return add

def mul_church(m, n):
    """Return the Church numeral for m * n, for Church numerals m and n.
    """
    "*** YOUR CODE HERE ***"
    def mul(f):
        return m(n(f))
    return mul

def pow_church(m, n):
    """Return the Church numeral m ** n, for Church numerals m and n.
    """
    "*** YOUR CODE HERE ***"
    def _pow(f):
        return lambda x: n(m(f))(m(f)(x))
    return _pow
```

### Environment Diagrams

这部分的内容像是补充关于栈帧的知识与C语言中指针与地址的关系。具体分析不难。

## lab04

通关！！

```shell
$ python ok -q riffle --local
=====================================================================
Assignment: Lab 4
OK, version v1.18.1
=====================================================================

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Running tests

---------------------------------------------------------------------
Test summary
    1 test cases passed! No cases failed.
```

可能是做过一些算法题，这些递归还是比较简单的。对于List Comprehension的用法倒是熟悉了一点。riffle这个已经比较复杂了，主要是推导出洗牌方式中下标的规律。

```python
def riffle(deck):
    """Produces a single, perfect riffle shuffle of DECK, consisting of
    DECK[0], DECK[M], DECK[1], DECK[M+1], ... where M is position of the
    second half of the deck.  Assume that len(DECK) is even.
    >>> riffle([3, 4, 5, 6])
    [3, 5, 4, 6]
    >>> riffle(range(20))
    [0, 10, 1, 11, 2, 12, 3, 13, 4, 14, 5, 15, 6, 16, 7, 17, 8, 18, 9, 19]
    """
    "*** YOUR CODE HERE ***"
    return [deck[(len(deck) // 2) * (i % 2) + i // 2] for i in range(len(deck))]
```

## lab05

这个lab主要是关于数据抽象与树的遍历。数据抽象的概念理解起来比较容易，所以题目都不怎么难。树的遍历主要是搜索，算法题做多的话也能比较快的写出来，所以反而这个lab做的更快一些。
### Q9: Add trees

这个问题主要是需要实现两棵树的同步遍历，所以写起来会复杂一点。主要是要处理好两个树分支个数不一致时的情况，总体的遍历思路就是深度优先的思路就行。

```python
def add_trees(t1, t2):
    "*** YOUR CODE HERE ***"
    if t1 == None:
        return tree(label(t2), branches(t2))
    elif t2 == None:
        return tree(label(t1), branches(t1))
    temp = []
    branches1, branches2 = branches(t1), branches(t2)
    for branch1, branch2 in zip(branches1, branches2):
        temp.append(add_trees(branch1, branch2))
    
    if len(branches1) == len(branches2):
        return tree(label(t1) + label(t2), temp)
    else:
        n = min(len(branches1), len(branches2))
        long_branches = branches1 if len(branches1) > len(branches2) else branches2
        for i in range(n, len(long_branches)):
            temp.append(add_trees(None, long_branches[i]))
        return tree(label(t1) + label(t2), temp)
```


## lab06

### WWPD: Iterators

iter()函数可以对一个迭代器用，但是返回的仍然是原来的迭代器，也就是课程中所说的

>but calling `iter` on a bookmark gives you the bookmark itself, without changing its position at all

具体的例子如下所示：
```python
a = iter([1,2,3,4,5])
next(a) // 1
b = iter(a)
next(b) // 2
next(a) // 3
```

```python
>>> r = range(6)
>>> r_iter = iter(r)
>>> next(r_iter)
>>> [x + 1 for x in r]
? [1, 2, 3, 4, 5, 6]
```

### Repeated

这题刚开始是想用两个迭代器，然后模拟两重for来做的，但是发现对迭代器使用iter() 并不能创建一个迭代器副本。后面发现其实是自己想复杂了，用一个cnt变量判断就可以。

```python
def repeated(t, k):
    assert k > 1
    "*** YOUR CODE HERE ***"
    lastValue = -1
    cnt = 0
    while True:
        curr = next(t)
        if curr == lastValue:
            cnt += 1
            if cnt == k:
                return curr
        else:
            lastValue = curr
            cnt = 1
```

## lab07

学习OOP（面向对象编程）

python的实例与类的访问方式有点不同。Class.xxx() 可以**返回类中已定义的部分**，否则报错，Class.xxx(instance) 则相当于传入了self函数，**等价于用实例运行**。Class.xxx() 也可以**接收子类的实例**，但是调用的方法肯定是**Class类本身的方法**了。

具体的实验内容网页上讲的还是比较详细的，没有什么思维难点。

## lab08

### Q7: Prune Small

题目要求对树的一些分支进行剪枝，需要进行填空，所以揣测它提供的思路比较麻烦。
其实分成两个子逻辑，首先将最大的几个分支从branches中删去，然后对每个子分支递归运行。

```python
def prune_small(t, n):
    """Prune the tree mutatively, keeping only the n branches
    of each node with the smallest labels.

    >>> t1 = Tree(6)
    >>> prune_small(t1, 2)
    >>> t1
    Tree(6)
    >>> t2 = Tree(6, [Tree(3), Tree(4)])
    >>> prune_small(t2, 1)
    >>> t2
    Tree(6, [Tree(3)])
    >>> t3 = Tree(6, [Tree(1), Tree(3, [Tree(1), Tree(2), Tree(3)]), Tree(5, [Tree(3), Tree(4)])])
    >>> prune_small(t3, 2)
    >>> t3
    Tree(6, [Tree(1), Tree(3, [Tree(1), Tree(2)])])
    """
    while len(t.branches) > n:
        largest = max(t.branches, key=lambda t: t.label)
        t.branches.remove(largest)
    for branch in t.branches:
        prune_small(branch, n)
```

## lab09

这个lab确实上强度了，好tm的难，思考的体量挺大的，不过也是学到了一些知识。

### Q1: Subsequences

还是那句话，填空比自己想麻烦多了。因为有两个函数要实现，所有要自己保证一下两个函数分别的正确性。注意insert_into_all是**返回一个新的list，而不是原地修改**。

```python
def insert_into_all(item, nested_list):
    res = []
    # print("DEBUG: nested_list", nested_list, ", item ", item)
    for lst in nested_list:
        temp = lst[:]
        # print("DEBUG: temp", temp)
        temp.insert(0, item)
        res.append(temp)
    return res


def subseqs(s):
    if len(s) == 0:
        return [[]]
    else:
        res = subseqs(s[1:])
        return res + insert_into_all(s[0], res)
```

### Q3: Number of Trees

收获最多的一集，卡特兰数之前做[01序列的个数](https://www.acwing.com/problem/content/891/) 用学习到，当时y总说卡特兰数用处很多，这次是真见识到了。

一种卡特兰数的推导形式是：
n 个数有多少种合法的进出栈顺序：把进栈表示成+1，出栈表示-1，那么**等价于求所有操作序列的前缀和没有出现过 小于0 的 方案数**。可以用所有方案数 - 非法方案数得出。所有方案数为$C^{2n}_n$ （n个+1，n个-1，一共2n个位置）， 非法方案数则可以这样考虑，当首次出现和为-1的位置，此时将前面的操作序列全部取相反数，这样可以得到一个有 n + 1个 +1 和  n - 1个-1的操作序列，所以方案数为 $C^{2n}_{n-1}$ ，这样最终的方法数为$$H(n)=C^{2n}_{n}- C^{2n}_{n-1}=\frac{1}{n+1}C^{2n}_{n}$$
另一种卡特兰数的形式是求和的形式，本题就可以使用这种方法。我们可以把分成一个完全二叉树分成两个部分，一个部分包含 i 个叶子节点，另一个部分包含 n - i 个叶子节点，则$$H(n) = \sum^{n - 1}_{i = 1} {H_{i} * H_{n - i}}$$
由于题目要求是完全二叉树，所以每个分支至少有一个叶子节点。

**[卡特兰数的一些常见问题形式](https://zhuanlan.zhihu.com/p/694653197)**，总结一下卡特兰数的一些衍生问题。

- 有n对括号，有多少种合法括号的序列：可以把左括号看成+1，右括号看成-1
- 网格中走到 （n, n）且路线不超过 y = x的方案数：也可以把向右看成+1，向上看成-1
- n+2的多边形有多少条对角线：可以用第二种卡特兰数的推导方法，可以将n+2多边形看成由一个三角形分成左右两个多边形，也是相同的求和方式。


```python
def num_trees(n):
    if n == 1:
        return 1
    res = 0
    for i in range(1, n):
        res += num_trees(i) * num_trees(n - i)
    return res
```


### Q4: Partition Generator

这是我第三次说填空比较难了。一个比较恶心的地方是题目中给出的`yield ____` 下意识就觉得不能用yield from了，就怎么也做不对。其实是可以**接着写`yield from` 的**。

说一下题目中helper函数的入参含义吧，**j 表示剩下需要多少才可以达到n，k表示可以使用的最大的元素值**。

另外，题目中说了**返回列表的顺序与列表内的顺序都不重要**！直接使用测试程序会返回错误，但其实是对的。

```python
def partition_gen(n):
    """
    >>> for partition in partition_gen(4): # note: order doesn't matter
    ...     print(partition)
    [4]
    [3, 1]
    [2, 2]
    [2, 1, 1]
    [1, 1, 1, 1]
    """
    def yield_helper(j, k):
        if j == 0:
            yield []
        elif k > 0 and j > 0:
            for small_part in yield_helper(j - k, k):
                yield small_part + [k]
            yield from yield_helper(j, k - 1)
    yield from yield_helper(n, n)
```

### Q6: Trade

这题刚开始又思维定势了，觉得equal_prefix就是判断两个列表是否有前缀相等，完全没想到**可以放到while里作为一个条件使用**，其实这是对内部函数具有状态的进一步使用。

```python
def trade(first, second):
    m, n = 1, 1

    equal_prefix = lambda: sum(first[:m]) == sum(second[:n])
    while m <= len(first) and n <= len(second) and not equal_prefix():
        if sum(first[:m]) < sum(second[:n]):
            m += 1
        else:
            n += 1

    if equal_prefix():
        first[:m], second[:n] = second[:n], first[:m]
        return 'Deal!'
    else:
        return 'No deal!'
```

### Q7: Shuffle

这个和[[Lab_Record#lab04]] 里面的一个题目很像，逻辑是类似的。

```python
def shuffle(cards):
    assert len(cards) % 2 == 0, 'len(cards) must be even'
    half = cards[len(cards) // 2:]
    shuffled = []
    for i in range(len(cards) // 2):
        shuffled.append(cards[i])
        shuffled.append(half[i])
    return shuffled
```


### Q11: Long Paths

没想到，栽在了一个很蠢的地方，注意判断**是否是叶子节点是一个方法！！而不是属性！！**，要用`is_leaf()`而不是`is_leaf`

```python
def long_paths(t, n):
    def helper(t, path):
        # print("DEBUG:", t.label, t.is_leaf())
        if t.is_leaf():
            if len(path) >= n:
                temp = path[:]
                temp.append(t.label)
                # print("DEBUG:", temp)
                return [temp]
            else:
                return []
        path.append(t.label)
        res = []
        # print("DEBUG:", path)
        for branch in t.branches:
            res += helper(branch, path)
        path.pop()
        return res

    return helper(t, [])
```

## lab10

疑惑我的很多内容在lab10里得到了解答。

### Q6: Make a List

可以用课程提供的[在线scheme解释器](https://code.cs61a.org/scheme)用draw 子程序画出数据结构，做这个问题非常好用。
```scheme
(define lst '((1) 2 (3 4) 5))
```

### Q7: List Duplicator

复制可以理解成一个递归的过程，我这里没有处理好1个数字的情况，所以分成了三类讨论。

```scheme
(define (duplicate lst) (cond ((> (length lst) 1) (cons (car lst) (cons (car lst) (duplicate (cdr lst)))))
                              ((= (length lst) 1) (list (car lst) (car lst)))
                              (else ())))
```

还看到大佬的用let设置变量的写法，比较厉害，可以参考。

```scheme
(define (duplicate lst)
    (if (null? lst) 
        nil
        (let 
            (
                (rest (cdr lst))
                (first (car lst))
            )
            (cons first (cons first (duplicate rest)))
        )
    )
)
```

## lab11

和project scheme 真的是没法比，这个实验很简单，可能也是因为选做的原因。没啥好说的。



## lab12

### Q4: Repeat

这题是宏的应用，主要卡的地方在于expr比较难处理，如果用了逗号先把值算出来，那么就不能达到调用函数的目的，如果先引号，那么就无法把expr实际代表的表达式传进去。所以使用了`',`这样在解析时，**会解析成`quote expr`即实际的表达式的样**子。

但是仍然有一个问题就是此时expr是一个call expr，不能直接执行。所以我们可以用**eval 命令或者是创建一个lambda表达式来做**。

```scheme
(define-macro (repeat n expr)
  `(repeated-call ,n ',expr))

; Call zero-argument procedure f n times and return the final result.
(define (repeated-call n f)
  (if (= n 1)
      (eval f)
      (begin (eval f) (repeated-call (- n 1) f))))
```

## lab13

### Q3: Room Sharing

这题需要我们统计每门课有多少共用的房间，看上去比较简单，但是实际sql写起来感觉时间复杂度很高，需要进行自表连接，仅从实现上考虑，比较容易。

注意这里DISTINCT的使用，如果没有DISTINCT，会出现同一个教室，因为被多个课程公用了，所以会有多条记录，导致计数重复了，因此要进行去重。

```sql
CREATE TABLE sharing AS
  SELECT a.course, COUNT(DISTINCT a.hall) AS shared
  FROM finals AS a, finals AS b
  WHERE a.hall = b.hall AND a.course != b.course
  GROUP BY a.course;
```

### Q4: Two Rooms

这题主要是感觉sql太灵活了，有时候主要是自己不敢想导致的。这里其实类似于a.seats + b.seats当成了一个新的列，然后我们在这个列上进行筛选。

```sql
CREATE TABLE pairs AS
  SELECT a.room || " and " || b.room || " together have " || (a.seats + b.seats) || " seats"
  FROM sizes AS a, sizes AS b
  WHERE a.room < b.room AND a.seats + b.seats >= 1000
  ORDER BY (a.seats + b.seats) DESC;
```