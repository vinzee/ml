# Cross Validation - http://scikit-learn.org/stable/modules/cross_validation.html
import numpy as np
import matplotlib.pyplot as plt
import pydotplus
from StringIO import StringIO
from sklearn import datasets, tree
from sklearn.neighbors import KNeighborsClassifier
from sklearn import linear_model
from sklearn.model_selection import cross_val_score

digits = datasets.load_digits()

for val in range(len(digits.target)):
	digits.target[val] = (1 if digits.target[val] == 9 else 0)

print "Decision tree"
# http://scikit-learn.org/stable/modules/tree.html
clf1 = tree.DecisionTreeClassifier()
clf1 = clf1.fit(digits.data, digits.target)
scores = cross_val_score(clf1, digits.data, digits.target, cv=10)
print scores
print("Accuracy: %0.2f" % scores.mean())
# print clf1.feature_importances_
# [29, 21, 43, 51, 42, 33, 46]

print "1-nearest neighbor"
# http://scikit-learn.org/stable/modules/neighbors.html
clf2 = KNeighborsClassifier(n_neighbors=1)
clf2 = clf2.fit(digits.data, digits.target)
scores = cross_val_score(clf2, digits.data, digits.target, cv=10)
print scores
print("Accuracy: %0.2f" % scores.mean())

print "Logistic regression classifier"
# http://scikit-learn.org/stable/auto_examples/linear_model/plot_iris_logistic.html
clf3 = linear_model.LogisticRegression() # C=1e5
clf3 = clf3.fit(digits.data, digits.target)
scores = cross_val_score(clf3, digits.data, digits.target, cv=10)
print scores
print("Accuracy: %0.2f" % scores.mean())

# fi = np.reshape(clf1.feature_importances_, (8,8))
# print fi
# plt.imshow(fi, cmap="Greys_r", interpolation='none')
# plt.show()

# dotfile = StringIO()
# tree.export_graphviz(clf1, out_file = dotfile, class_names = ['-', '+'], rounded = True) # , feature_names = ['1', '0'])
# graph = pydotplus.graph_from_dot_data(dotfile.getvalue())
# graph.write_pdf("clf1.pdf")

# Z = np.reshape(clf3.coef_, (8,8))
# print Z
# plt.imshow(Z, cmap="Greys_r", interpolation='none')
# plt.show()
