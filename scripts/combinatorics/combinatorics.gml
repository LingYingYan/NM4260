/// permutations(arr, k)
/// @param {array} arr 1D array of input elements
/// @param {real} k desired permutation length
/// @return {array<array>} 2D array (array of arrays). Each child array has length k.

function permutations(arr, k) {
    var n = array_length(arr);
    var results = []; // will hold arrays (each a permutation)

    // edge cases
    if (k < 0) {
        return results;
    }
    
    if (k == 0) {
        array_push(results, []); // one permutation: empty array
        return results;
    }
    
    if (k > n) {
        array_push(results, arr);
        return results;
    }

    // state for backtracking
    var used = array_create(n);
    for (var i = 0; i < n; i += 1) {
        used[i] = false;
    }
    
    var current = array_create(k);
    
    function backtrack_permute(depth, k, n, results, arr, used, current) {
        if (depth == k) {
            // copy current into a new array (so we don't keep references)
            var copy = array_create(k);
            for (var t = 0; t < k; t += 1) {
                copy[t] = current[t];
            }
                
            array_push(results, copy);
            return;
        }
            
        for (var i = 0; i < n; i += 1) {
            if (!used[i]) {
                used[i] = true;
                current[depth] = arr[i];
                backtrack_permute(depth + 1, k, n, results, arr, used, current);
                used[i] = false;
            }
        }
    }

    backtrack_permute(0, k, n, results, arr, used, current);
    return results;
}


