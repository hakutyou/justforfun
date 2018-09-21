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

        @PyQt5.QtCore.pyqtSlot(str)
        def output(self, string):
                print(string)

        @PyQt5.QtCore.pyqtSlot(str, result=list)
        def finder(self, find_string):
                lst = self.search.fuzzy_finder(find_string)
                return list(map(lambda x: {'name': self._basename(x), 'path': x}, lst))

        @PyQt5.QtCore.pyqtSlot(str, result=str)
        def reader(self, path):
                with open(self.data_directory + path, 'r') as file:
                        result = file.read()
                return result
