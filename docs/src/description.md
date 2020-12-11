# Description

Questo modulo implementa due principali algortimi:
 - segmentazione:
 - orthophoto:

## Input Point Cloud
Le nuvole di punti in input per questo modulo sono dei progetti Potree, una struttura basata su octree descritta da MArk schuez  

### Potree

A Potree is a data structure, based on octree, described by Markus Schütz [link da inserire].

![potree][images/Octree.jpg "Potree: Root node in orange, first child in red, and its second child in blue."]

A Potree project is a collection of files, for each node of the octree there is a file called r, followed by a numeric code indicating its position in the hierarchy, for example:
 - r is the root node,
 - r0 is the first child of the root node,
 - r07 is the eighth child of the first child of the root node.


Due to particular way of tagging nodes, it is possible store Potree in a trie data structure, provided by Julia in module `DataStructures.jl`. As the usual tree data structure, a trie is made up of collections of trie node. Every trie node has three components:
- a value, where store information: in our case the path to the file associated;
- a map, where key is character and the value is trie node, used to establish the parent-child relationship;
- boolean value, indicating the end of word.


#### Traversal of a trie

descrizione del traversal dei trie

### Create image
raster image

### Segment
salvataggio dei punti che ricadono nel modello
