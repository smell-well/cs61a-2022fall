通关！！

```python
Point breakdown
    Problem 1: 1.0/1
    Problem 2: 1.0/1
    Problem 3: 2.0/2
    Problem 4: 1.0/1
    Problem 5: 2.0/2
    Problem 6: 3.0/3
    Problem 7: 3.0/3
    Problem 8: 2.0/2
    Problem 9: 2.0/2
    Problem 10: 2.0/2

Score:
    Total: 19.0
```
## Phase 1

阶段1比较简单，认真读题就可以。

## Phase 2

### Problem 5 (2 pts)

提炼一下要求：
- 如果 typed 在 dict 里，直接返回 typed
- 找到与 typed 差异最小（多个时取下标最下）的 dict 里的单词
- 如果差异超过 limit，直接返回 typed

```python
def autocorrect(typed_word, word_list, diff_function, limit):
    """Returns the element of WORD_LIST that has the smallest difference
    from TYPED_WORD. Instead returns TYPED_WORD if that difference is greater
    than LIMIT.

    Arguments:
        typed_word: a string representing a word that may contain typos
        word_list: a list of strings representing source words
        diff_function: a function quantifying the difference between two words
        limit: a number

    >>> ten_diff = lambda w1, w2, limit: 10 # Always returns 10
    >>> autocorrect("hwllo", ["butter", "hello", "potato"], ten_diff, 20)
    'butter'
    >>> first_diff = lambda w1, w2, limit: (1 if w1[0] != w2[0] else 0) # Checks for matching first char
    >>> autocorrect("tosting", ["testing", "asking", "fasting"], first_diff, 10)
    'testing'
    """
    # BEGIN PROBLEM 5
    "*** YOUR CODE HERE ***"
    if typed_word in word_list:
        return typed_word
    
    min_diff = limit + 1
    res = typed_word
    for word in word_list:
        # if typed_word == word:
        #     print("DEBUG:" + typed_word + " " + word)
        #     return typed_word
        diff = diff_function(typed_word, word, limit)
        # print("DEBUG:" + typed_word + " " + word + ", diff " + str(diff))
        if diff < min_diff:
            min_diff = diff
            res = word
    # limit 为浮点数时
    if min_diff > limit:
        return typed_word
    return res
```

### Problem 7 (3 pts)

这题其实就是递归版本的 [编辑距离](https://leetcode.cn/problems/edit-distance/)，需要根据题目限制做一点修改。
首先是运行时间上的限制，题目要求超过 limit 可以提前结束，所以**在递归时需要对 limit 判断**，提前结束。如果是不加剪枝的递归，会报如下错误。
```python
>>> len([line for line in output.split('\n') if 'funcname' in line]) < 1000
False
```

这题我是从动态规划角度思考的，递归相当于是自顶向下的获取答案。
dp i，j 表示source字符串的前 i 个字符，j 则是target字符串的前 j 个字符，可以分成以下三种状态：
- 插入一个字母：dp i, j - 1 + 1；相当于 target 少比较了一个
- 删除一个字母：dp i - 1, j + 1；相当于 source 少比较一个
- 替换一个字母：dp i - 1, j - 1 + (0 if start[i] == goal[j] else 1)；都少了比较一个

```python
def minimum_mewtations(start, goal, limit):
    """A diff function that computes the edit distance from START to GOAL.
    This function takes in a string START, a string GOAL, and a number LIMIT.
    Arguments:
        start: a starting word
        goal: a goal word
        limit: a number representing an upper bound on the number of edits
    >>> big_limit = 10
    >>> minimum_mewtations("cats", "scat", big_limit)       # cats -> scats -> scat
    2
    >>> minimum_mewtations("purng", "purring", big_limit)   # purng -> purrng -> purring
    2
    >>> minimum_mewtations("ckiteus", "kittens", big_limit) # ckiteus -> kiteus -> kitteus -> kittens
    3
    """
    n = len(start)
    m = len(goal)
    def helper(i, j, need):
        if need > limit:
            return need
        if i == -1:
            return need + j + 1
        elif j == -1:
            return need + i + 1
        else:
            add = helper(i, j - 1, need + 1)
            remove = helper(i - 1, j, need + 1)
            substitute = helper(i - 1, j - 1, need + (0 if start[i] == goal[j] else 1))
            res = min(add, remove, substitute)
            return res
    return helper(n - 1, m - 1, 0)
```

### (Optional) Extension: final diff (0pt)

这题自由发挥，提高校正的正确率。
根据 score 中的错例，增加了一条修正规则，如果是首字母大写或者全大小写的情况就不算修改的次数。做了一些简单的对比，因为每次 score 的测试用例都是随机的，所以不能完全保证评价的公平。Acc 表示准确率，Corrected / All words

仅从这不完全的验证看，提升效果还是不错的。

```python
def final_diff(typed, source, limit):
    """A diff function that takes in a string TYPED, a string SOURCE, and a number LIMIT.
    If you implement this function, it will be used."""
    # minimum_mewtations (baseline) Acc 71.3%
    # Correction Speed: 320.82898348246624 wpm
    # Correctly Corrected: 172 words
    # Incorrectly Corrected: 54 words
    # Uncorrected: 15 words

    # 增加一条规则，相同字母变大写不会增加次数 Acc 70.1% (不理想)
    # Correction Speed: 277.27331101660457 wpm
    # Correctly Corrected: 146 words
    # Incorrectly Corrected: 40 words
    # Uncorrected: 22 words

    # 仅对首字母 Acc 69.0% 
    # Correction Speed: 326.42717092195034 wpm
    # Correctly Corrected: 169 words
    # Incorrectly Corrected: 46 words
    # Uncorrected: 30 words

    # 全大写校验 Acc 68.9%
    # Correction Speed: 341.9772880314324 wpm
    # Correctly Corrected: 177 words
    # Incorrectly Corrected: 59 words
    # Uncorrected: 21 words
    
    # 首字母大写 + 全大写校验 Acc 75.7%
    # Correction Speed: 279.17753688419293 wpm
    # Correctly Corrected: 159 words
    # Incorrectly Corrected: 39 words
    # Uncorrected: 12 words

    # 首字母大写 + 全大写校验 Acc 77.1%
    # Correction Speed: 301.4019370010115 wpm
    # Correctly Corrected: 175 words
    # Incorrectly Corrected: 37 words
    # Uncorrected: 15 words    
    
    # 全大小写校验
    if typed.lower == source or typed.upper == source:
        return 0
    n = len(typed)
    m = len(source)
    def helper(i, j, need):
        if need > limit:
            return need
        if i == -1:
            return need + j + 1
        elif j == -1:
            return need + i + 1
        else:
            add = helper(i, j - 1, need + 1)
            remove = helper(i - 1, j, need + 1)
            # 首字母大写
            if typed[i] == source[j] or (i == 0 and j == 0 and typed[i].upper == source[j]):
                substitute = helper(i - 1, j - 1, need)
            else:
                substitute = helper(i - 1, j - 1, need + 1)
            res = min(add, remove, substitute)
            return res

    return helper(n - 1, m - 1, 0)
```


## Phase 3
### Problem 9 (2 pts)

这个其实没有什么难的，主要是要注意一下，match要用提供的match函数实现，不然有些样例会报错的。

```python
def time_per_word(words, times_per_player):
    """Given timing data, return a match dictionary, which contains a
    list of words and the amount of time each player took to type each word.

    Arguments:
        words: a list of words, in the order they are typed.
        times_per_player: A list of lists of timestamps including the time
                          the player started typing, followed by the time
                          the player finished typing each word.

    >>> p = [[75, 81, 84, 90, 92], [19, 29, 35, 36, 38]]
    >>> match = time_per_word(['collar', 'plush', 'blush', 'repute'], p)
    >>> match["words"]
    ['collar', 'plush', 'blush', 'repute']
    >>> match["times"]
    [[6, 3, 6, 2], [10, 6, 1, 2]]
    """
    # BEGIN PROBLEM 9
    diff = [[player[i] -  player[i - 1] for i in range(1, len(player))] \
         for player in times_per_player]
    res = match(words, diff)
    return res
    # END PROBLEM 9
```

#### 关于多人对战

由于下载的zip文件中缺少GUI的部分，因此无法测试效果了。