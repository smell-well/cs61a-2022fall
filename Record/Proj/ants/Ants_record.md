
## Extra Credit

这题由于限制不能修改bee类，所以感觉做起来很复杂。难点在 SlowAnt的throw_at函数要实现记录每个bee的减速状态，然后还要修改bee的action函数。

python里面类的函数比java要灵活很多，**类的函数可以在其他类中进行修改**，如下所示。
```python
class Base:
    def action(self, state):
        print("Base action!")
        return

class A(Base):
    def action(self, state):
        print("A action!")
        return

class B(Base):
    def action(self, state):
        print("B action!")
        return

    def throw_at(self, target):
        target.action = self.action
        return

a = A()
b = B()

b.throw_at(a)
a.action([])
# B action!
```

因此，通过上面我们可以解决bee.action可以有不同行为的问题。第二个需要解决的是追踪每个bee的状态，一开始是想在SlowThrower里维护一个字典，但是不一样的是即使把**bee.action指向了SlowThrower里面的函数，调用时 self 仍然指向的是 SlowThrower**。

这里又可以用到python灵活的地方了，**可以直接给 bee 添加成员变量**！

```python
class SlowThrower(ThrowerAnt):
    """ThrowerAnt that causes Slow on Bees."""

    name = 'Slow'
    food_cost = 6
    # BEGIN Problem EC
    turns_to_slow = 5
    implemented = True   # Change to True to view in the GUI
    # END Problem EC

    @classmethod
    def slowed_action(cls, bee):
        origin_func = bee.origin_func
        def slow_action(gamestate):
            print("DEBUG: bee slow turn", bee.slow_turn)
            bee.slow_turn -= 1
            if bee.slow_turn >= 0 and gamestate.time % 2 != 0:
                return
            elif bee.slow_turn < 0:
                bee.action = bee.origin_func
            origin_func(gamestate)
        return slow_action

    def throw_at(self, target):
        # BEGIN Problem EC
        "*** YOUR CODE HERE ***"
        if not hasattr(target, 'slow_turn'):
            target.origin_func = target.action
        # 灵活的python
        target.slow_turn = self.turns_to_slow
        target.action = SlowThrower.slowed_action(target)
        # END Problem EC

```