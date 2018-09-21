import os
import re


class Searcher:
        def __init__(self, directory):
                self.directory = directory
                self.file_list = []
                self.walk()

        def fuzzy_finder(self, fuzzy):
                suggestions = []
                pattern = '.*?'.join(fuzzy)  # Converts 'djm' to 'd.*?j.*?m'
                regex = re.compile(pattern)  # Compiles a regex.
                for item in self.file_list:
                        match = regex.search(
                                item)  # Checks if the current item matches the regex.
                        if match:
                                suggestions.append(
                                        (len(match.group()), match.start(), item))
                return [x for _, _, x in sorted(suggestions)]

        def walk(self, local_directory='', _index=0, _addition=0):
                length = len(self.file_list) - _addition
                full_directory = self.directory + local_directory
                for file in os.listdir(full_directory):
                        full_path = full_directory + '/' + file
                        local_path = local_directory + '/' + file
                        if os.path.isdir(full_path):
                                _index, _addition =\
                                        self.walk(local_path, _index, _addition)
                        else:
                                # pre_in_list = self._basename(local_path)
                                while True:
                                        if _index >= length:
                                                self.file_list.append(local_path)
                                                _addition += 1
                                                break
                                        in_list = self.file_list[_index]
                                        if in_list < local_path:
                                                del self.file_list[_index]
                                                length -= 1
                                                continue
                                        if in_list == local_path:
                                                _index += 1
                                                continue
                                        self.file_list.append(local_path)
                                        _addition += 1
                                        break
                return _index, _addition

        def clear(self):
                del self.file_list[:]
