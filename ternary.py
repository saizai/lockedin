def output_ternary_tree(alphabet, split, i, j, depth = 0):
  if i == j: return
  k = split[(i,j)]
  output_ternary_tree(alphabet, split, i, k, depth+1)
  print (" "*depth)+str(alphabet[k])
  output_ternary_tree(alphabet, split, k+1, j, depth+1)

def optimal_ternary_tree(frequencies, alphabet = None):
  if alphabet == None: alphabet = range(len(frequencies))
  sum = {}
  mean_time = {}
  split = {}
  for j in range(len(frequencies)+1):
    sum[(j,j)] = 0
    mean_time[(j,j)] = 0
    for i in range(j-1,-1,-1):
      sum[(i,j)] = frequencies[i] + sum[(i+1,j)]
      best_time = float("inf")
      for k in range(i,j):
        time = (sum[(i,k)]*(1+mean_time[(i,k)]) + frequencies[k] + sum[(k+1,j)]*(1+mean_time[(k+1,j)])) / sum[(i,j)]
        if time < best_time:
          best_time = time
          best_k = k
      split[(i,j)] = best_k
      mean_time[(i,j)] = best_time
  output_ternary_tree(alphabet, split, 0, len(frequencies))
  print mean_time[(0,len(frequencies))]

def binary_tree(frequencies, alphabet = None, depth = 0): # lazier
  if alphabet == None: alphabet = range(len(frequencies))
  if len(frequencies) <= 1:
    if len(frequencies) == 1: 
      print (" "*depth)+alphabet[0]
      return depth*frequencies[0]
    else:
      return 0
  s = sum(frequencies)
  partial = 0
  for k in range(len(frequencies)):
    partial += frequencies[k]
    if partial >= s/2.0: break
  if (s/2.0 - (partial - frequencies[k])) > (partial - s/2.0): k = k + 1
  total_time = binary_tree(frequencies[:k], alphabet[:k], depth + 1)
  print (" "*depth)+"*"
  total_time += binary_tree(frequencies[k:], alphabet[k:], depth + 1)
  return total_time

freqs = [8.167,	
1.492,	
2.782,	
4.253,	
12.702,	
2.228,	
2.015,	
6.094,	
6.966,	
0.153,	
0.772,	
4.025,	
2.406,	
6.749,	
7.507,	
1.929,	
0.095,	
5.987,	
6.327,	
9.056,	
2.758,	
0.978,	
2.360,	
0.150,	
1.974,	
0.074] 	# single-letter frequencies from Wikipedia
print binary_tree(freqs, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') / sum(freqs)

