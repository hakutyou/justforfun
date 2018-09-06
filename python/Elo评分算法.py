class Elo:
    K = 32

    def __init__(self, Ra, Rb):
        self.Ra = Ra
        self.Rb = Rb

    @property
    def Ea(self): # A 胜利的概率
        return 1/(1+10**((self.Rb - self.Ra)/400))

    @property
    def Eb(self): # B 胜利的概率
        return 1/(1+10**((self.Ra - self.Rb)/400))

    def match(self, Sa):
        delta_Ra = self.K * (Sa - self.Ea)
        self.Ra += delta_Ra
        self.Rb -= delta_Ra

    def print(self):
        print('Ra=%d, Rb=%d' % (self.Ra, self.Rb))
        print('Ea=%f, Eb=%f' % (self.Ea, self.Eb))

a = Elo(0, 0)
a.print()
for i in range(1,20):
    a.match(1) # A 胜利
    a.print()
for i in range(1,8):
    a.match(0) # B 胜利
    a.print()
a.match(0.5) # 平局
