python cifar10_train.py
python cifar10_eval.py
tensorboard --logdir=/tmp/cifar10_train;/tmp/cifar10_eval
------------------------------------------------------------------------------------------

No of iterations - 1000
Code to convert cifar10 to cifar2 dataset (written in Ruby) contained in - parse.rb
All models have been for 1000 max iterations.
Initial Accuracy - 0.894

Types of changes I tried - 
1. Increase / Decrease CONV+POOL+NORM layers
2. Increase / Decrease FC layers
3. Increase / Decrease Kernel (Filter) size
4. Increase / Decrease Max_Pool size
5. Increase / Decrease Learning Rate
6. Introduce Dropouts

Default Model architecture - 
CONV -> POOL -> NORM -> CONV -> NORM -> POOL -> FC -> FC -> SOFTMAX

------------------------------------Changes------------------------------------
Unchaged Model Stats - 
2017-04-09 20:35:48.922687: step 0, loss = 3.07 (119.9 examples/sec; 1.067 sec/batch)
2017-04-09 20:37:57.239338: step 100, loss = 2.94 (145.2 examples/sec; 0.882 sec/batch)
2017-04-09 20:45:29.855506: step 500, loss = 2.05 (123.7 examples/sec; 1.035 sec/batch)
2017-04-09 20:55:10.061725: step 990, loss = 1.36 (103.7 examples/sec; 1.234 sec/batch)
2017-04-09 20:59:21.392819: precision @ 1 = 0.894
------------------------------------------------------------------------------------------
Change 1
Remove 1 FC layer
2017-04-10 19:13:38.334857: step 0, loss = 1.79 (38.4 examples/sec; 3.333 sec/batch)
2017-04-10 19:15:30.199919: step 100, loss = 1.55 (100.2 examples/sec; 1.277 sec/batch)
2017-04-10 19:23:17.202979: step 500, loss = 1.21 (116.2 examples/sec; 1.102 sec/batch)
2017-04-10 19:32:39.201087: step 990, loss = 0.79 (123.9 examples/sec; 1.033 sec/batch)
2017-04-10 19:33:14.276534: precision @ 1 = 0.869

Analysis
FC layer is meant to introduce a non-linearity in the data and classify it based on the features detected in the CONV layer. Removing one will decrease the accuracy as, it will relate lower amount of features to the classes resulting in miss-classification. 
------------------------------------------------------------------------------------------
Change 2
Add 1 FC layer + Remove 1 Conv+Pool+Norm
2017-04-10 22:51:35.519735: step 0, loss = 9.74 (129.3 examples/sec; 0.990 sec/batch)
2017-04-10 22:52:27.861780: step 100, loss = 8.86 (240.0 examples/sec; 0.533 sec/batch)
2017-04-10 22:56:50.513301: step 500, loss = 6.47 (228.4 examples/sec; 0.560 sec/batch)
2017-04-10 23:02:00.776780: step 1000, loss = 4.40 (246.4 examples/sec; 0.519 sec/batch)
2017-04-10 23:08:35.554691: precision @ 1 = 0.871

Analysis
By removing one layer of Conv+Pool+Norm, there is a obvious drop in the accuracy as fewer/smipler features are extracted from the image thus resulting in lower odds of classifing the data correctly.
------------------------------------------------------------------------------------------
Change 3
Add 1 Conv+Pool+Norm + Decrease Kernel size (3x3) + Decrease Max pool size (2x2) + Add 1 FC layer
2017-04-10 23:46:57.483440: step 0, loss = 1.47 (112.6 examples/sec; 1.136 sec/batch)
2017-04-10 23:48:32.894178: step 100, loss = 1.41 (93.5 examples/sec; 1.369 sec/batch)
2017-04-10 23:55:04.606440: step 500, loss = 0.98 (137.2 examples/sec; 0.933 sec/batch)
2017-04-11 00:10:37.507373: step 990, loss = 0.73 (174.5 examples/sec; 0.734 sec/batch)
2017-04-11 00:10:07.664351: precision @ 1 = 0.825

Analysis
Adding more conv+pool+norm layers can detect more complex features in the image.
Decreasing the kernel size increases the locality of the convolution, making it narrower.
Adding 1 more FC will try to factor in more non-linearity in the features already detected by the conv layer.
------------------------------------------------------------------------------------------
Change 4
Increase learning rate (0.2)
2017-04-09 23:19:06.973041: step 0, loss = 3.07 (123.1 examples/sec; 1.040 sec/batch)
2017-04-09 23:20:37.072487: step 100, loss = 2.78 (146.8 examples/sec; 0.872 sec/batch)
2017-04-09 23:44:47.935910: step 500, loss = 1.91 (65.5 examples/sec; 1.955 sec/batch)
2017-04-09 23:53:28.327674: step 990, loss = 1.35 (124.3 examples/sec; 1.030 sec/batch)
2017-04-09 23:56:16.337683: precision @ 1 = 0.895

Analysis
More learning rate means that the system increase weights faster and has a tendency to overfit. In this case, the accuracy increased by a small amount resulting in no loss.
------------------------------------------------------------------------------------------
Change 5
Add a dropout rate (0.75) at the last FC layer

2017-04-11 01:18:30.176568: step 0, loss = 3.06 (132.2 examples/sec; 0.968 sec/batch)
2017-04-11 01:20:56.615594: step 100, loss = 2.80 (92.4 examples/sec; 1.385 sec/batch)
2017-04-11 01:34:01.171697: step 500, loss = 1.97 (96.7 examples/sec; 1.323 sec/batch)
2017-04-11 01:47:36.840451: step 990, loss = 1.32 (98.9 examples/sec; 1.294 sec/batch)
2017-04-11 01:47:22.407121: precision @ 1 = 0.902

2017-04-11 11:39:48.621591: step 0, loss = 3.07 (115.9 examples/sec; 1.104 sec/batch)
2017-04-11 11:41:13.632959: step 100, loss = 2.74 (149.5 examples/sec; 0.856 sec/batch)
2017-04-11 11:49:09.158405: step 500, loss = 2.02 (115.6 examples/sec; 1.107 sec/batch)
2017-04-11 11:59:49.824251: step 1000, loss = 1.30 (111.4 examples/sec; 1.149 sec/batch)
2017-04-11 12:10:20.544418: step 1500, loss = 1.11 (63.8 examples/sec; 2.005 sec/batch)
2017-04-11 12:20:59.367277: step 2000, loss = 0.86 (122.9 examples/sec; 1.041 sec/batch)
2017-04-11 12:33:09.177761: step 2500, loss = 0.52 (57.0 examples/sec; 2.247 sec/batch)
2017-04-11 12:45:11.277393: step 3000, loss = 0.52 (54.1 examples/sec; 2.366 sec/batch)
2017-04-11 12:56:57.751289: step 3500, loss = 0.41 (49.4 examples/sec; 2.590 sec/batch)
2017-04-11 13:07:50.094229: step 4000, loss = 0.44 (80.6 examples/sec; 1.587 sec/batch)
2017-04-11 13:29:05.167141: step 5000, loss = 0.24 (112.9 examples/sec; 1.133 sec/batch)
2017-04-11 13:40:33.282620: step 5500, loss = 0.20 (113.7 examples/sec; 1.126 sec/batch)
2017-04-11 13:47:17.619896: step 5770, loss = 0.22 (106.7 examples/sec; 1.199 sec/batch)
2017-04-11 13:31:05.273371: precision @ 1 = 0.942

Analysis
Dropout randomly drops units from the neural network and helps to avoid overfitting in the training data.
In this case, a dropout of 0.75 has been introduced after the 2nd fully connected layer (local4). This increases the accuray of the model thus gives us better classification.
------------------------------------------------------------------------------------------
Change 6
Remove Image distortions (Preprocessing)
2017-04-09 23:19:06.973041: step 0, loss = 3.07 (123.1 examples/sec; 1.040 sec/batch)
2017-04-09 23:20:37.072487: step 100, loss = 2.78 (146.8 examples/sec; 0.872 sec/batch)
2017-04-09 23:44:47.935910: step 500, loss = 1.91 (65.5 examples/sec; 1.955 sec/batch)
2017-04-09 23:53:28.327674: step 990, loss = 1.35 (124.3 examples/sec; 1.030 sec/batch)
2017-04-11 02:21:14.504811: precision @ 1 = 0.879

Analysis
Removing the distortions would reduce the accuracy of the model as observed.
This is because clear images, give the model to activate on all the features in the image and not concentrate on the important ones which may actually be helpful in the classification.
