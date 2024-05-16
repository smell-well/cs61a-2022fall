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