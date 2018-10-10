import PyQt5.QtCore

import skill


class Interactive(PyQt5.QtCore.QObject):
        # mp = ''
        # nf = wf = rx = ng = wg = hs = 0
        attribute = {}

        def __init__(self, parent=None):
                super(Interactive, self).__init__(parent)

        @PyQt5.QtCore.pyqtSlot(str)
        def output(self, x):
                print(x)

        @PyQt5.QtCore.pyqtSlot(str, int)
        def set_attribute(self, attr, value):
                self.attribute[attr] = value

        @staticmethod
        def defence(x):
                return x / (0.9845 * x + 2761)

        @staticmethod
        def repress(differ):
                if differ <= -2000:
                        return 1.14
                if differ >= 2000:
                        return 1.7
                return round(1.42 + 0.00014 * differ, 5)

        def skill_damage(self, skill_coefficient):
                wg = self.attribute.get('wg', 0)
                ng = self.attribute.get('ng', 0)
                wf = self.attribute.get('wf', 0)
                nf = self.attribute.get('nf', 0)
                # power = self.attribute.get('hs', 0) - 0.8 * self.attribute.get('rx', 0)
                wg_real = wg * (1 - self.defence(wf)) * skill_coefficient
                ng_real = ng * (1 - self.defence(nf)) * skill_coefficient
                return str(round(wg_real+ng_real)) + '\t' + str(
                        round(ng_real))
                # + '\t' + str(
                # round((wg_real+ng_real) * power)) + '\t' + str(
                # round(ng_real * power))

        @PyQt5.QtCore.pyqtSlot(result=list)
        def get_result(self):
                def transform(item):
                        return {'name': item,
                                'value': self.skill_damage(skill_list[item])}
                try:
                        skill_list = skill.coefficient()[self.attribute.get('mp', '天香')]
                except KeyError:
                        skill_list = skill.coefficient()['天香']
                return list(map(transform, skill_list))


if __name__ == '__main__':
        interactive = Interactive()
        interactive.set_attr()
        print(interactive.get_result())
