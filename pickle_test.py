import pickle

good = [2,7]
def unpickle(file):
    
    fo = open(file, 'rb')
    dict = pickle.load(fo)
    fo.close()
    return dict

og_dict = unpickle('cifar-10-batches-bin/data_batch_1')


new_dict = {'data':[], 'labels':[], 'batch_label':[], 'filenames':[]}  

while i < len(dict['labels']):
	if dict['labels'][i] == 2 or og_dict['labels'][i] == 7:
		new_dict['data'].append(og_dict['data'][i])
		new_dict['labels'].append(og_dict['labels'][i])
		new_dict['filenames'].append(og_dict['filenames'][i])
		i += 1

new_dict['batch_label'].append(dict['batch_label'])


print(new_dict)