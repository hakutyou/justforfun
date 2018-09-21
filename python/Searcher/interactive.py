import os
import sys
import PyQt5.QtCore

import searcher


class Interactive(PyQt5.QtCore.QObject):
        def __init__(self, parent=None):
                super(Interactive, self).__init__(parent)
                # work_directory = os.path.abspath(os.path.dirname(__file__))
                work_directory = os.path.dirname(os.path.realpath(sys.argv[0]))
                self.data_directory = work_directory + '/data/'
                self.search = searcher.Searcher(self.data_directory)

        @staticmethod
        def _basename(filename):
                return os.path.splitext(filename)[0]

        def tuple_transform(self, lst):
                return list(map(lambda x: (self._basename(x), x), lst))

        @PyQt5.QtCore.pyqtSlot(str)
        def output(self, string):
                print(string)

        @PyQt5.QtCore.pyqtSlot(str, result=list)
        def finder(self, find_string):
                lst = self.search.fuzzy_finder(find_string)
                tup = self.tuple_transform(lst)
                return list(map(lambda x: {'name': x[0], 'path': x[1]}, tup))

        @PyQt5.QtCore.pyqtSlot(str, result=str)
        def reader(self, path):
                with open(self.data_directory + path, 'r') as file:
                        result = file.read()
                return result
