#!/usr/bin/env python

from sklearn import tree
from sklearn import preprocessing
import pydotplus
from StringIO import StringIO

# Training set
data = [
    [1, 0, 'r', 1],
    [0, 0, 'b', 0],
    [1, 1, 'g', 0],
    [0, 0, 'g', 0],
    [1, 1, 'b', 1],
    [0, 1, 'b', 1],
    [0, 0, 'r', 0],
    [1, 0, 'b', 0],
    [1, 1, 'r', 1]
]

# Transform discrete column to numeric
col = [row[2] for row in data]
le = preprocessing.LabelEncoder()
le.fit(col)
for idx, val in enumerate(le.transform(col)):
    data[idx][2] = val
print(str(le.classes_) + ' -> ' + str(le.transform(le.classes_)))


# Learn a decision tree
X = [row[:-1] for row in data]
Y = [row[-1] for row in data]
clf = tree.DecisionTreeClassifier()
clf = clf.fit(X, Y)

# See how well it works
classes = clf.predict([row[:-1] for row in data])
probs = clf.predict_proba([row[:-1] for row in data])
for row, cls, prob in zip(data, classes, probs):
    print(str(row) + ' ' + str(cls))

# Create picture of it
dotfile = StringIO()
tree.export_graphviz(clf, out_file = dotfile,
                     feature_names = ['Tall', 'Wide', 'Color'],
                     rounded = True, class_names = ['-', '+'])
graph = pydotplus.graph_from_dot_data(dotfile.getvalue())
graph.write_pdf("tree.pdf")
