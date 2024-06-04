**过关**
```python
Point breakdown
    Question 0: 0.0/0
    Question 1: 2.0/2
    Question 2: 2.0/2
    Question 3: 2.0/2
    Question 4: 1.0/1
    Question 5: 5.0/5
    Question 6: 2.0/2
    Question 7: 2.0/2
    Question 8: 2.0/2
    Question 9: 2.0/2
    Question 10: 2.0/2
    Question 11: 2.0/2
    Question 12: 0.0/0
```
### Phase 1

主要是完成游戏的主体结构，让游戏能正常玩起来。实现下来基本没有什么难点。

### Phase 2

#### Q8 WWPD
这个是真想不到啊，其实代码估计不会错，但是人算的时候没有转过弯来。
因为投2次，**且其中有1所以会因为规则直接变成1**，不能直接按骰子序列算。

```python
>>> from hog import *
>>> dice = make_test_dice(3, 1, 5, 6)
>>> averaged_roll_dice = make_averaged(roll_dice, 1000)
>>> # Average of calling roll_dice 1000 times
>>> # Enter a float (e.g. 1.0) instead of an integer
>>> averaged_roll_dice(2, dice)
```